#!/usr/bin/env bash
#
# validate-inner-values.sh
#
# Validates the INNER layer of aurora-platform-charts.
#
# The umbrella chart renders ArgoCD `Application` objects. CI (kubeconform)
# validates those Application objects, but it CANNOT see inside the
# `spec.source.helm.values: |` string block, which is the *upstream* chart's
# real configuration. Indentation slips, mistyped keys, and type errors in that
# block sail through CI and only break at ArgoCD sync time on a live cluster.
#
# This script closes that gap: for every rendered Application that installs a
# Helm chart, it extracts the upstream chart coordinates and the inline values,
# then runs `helm template <chart> --repo <repoURL> --version <rev> -f <values>`
# against the REAL upstream chart. Charts that ship a values.schema.json (like
# cert-manager) get their values schema-checked; all charts get YAML parse and
# Go-template type checking for free.
#
# Applications that source a chart but pass NO inline values are also checked:
# they are rendered with the upstream chart defaults (no -f), which confirms the
# chart name + targetRevision actually resolve and the chart renders. These are
# reported as "(defaults)".
#
# Not covered: Applications whose source is a git repo (no .spec.source.chart)
# or an OCI/non-http registry - they are neither selected nor pulled here.
#
# Usage:
#   tests/validate-inner-values.sh [--values <file>] [name-filter ...]
#
#   --values <file>   Helm values for the umbrella render (default: config/config.yaml)
#   name-filter       Optional substrings; only Applications whose metadata.name
#                     matches one of them are validated. No filter = validate all.
#
# Examples:
#   tests/validate-inner-values.sh cert-manager
#   tests/validate-inner-values.sh --values config/config.yaml cert-manager trust-manager
#   tests/validate-inner-values.sh            # everything (slow: pulls many charts)
#
# Requires: helm, yq (mikefarah v4+). Network access to the upstream chart repos.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHART_DIR="${REPO_ROOT}/stable/aurora-platform"
VALUES_FILE="${REPO_ROOT}/config/config.yaml"
RELEASE="aurora"
NAMESPACE="platform-management-system"

FILTERS=""   # space-separated substrings (bash 3.2 friendly; avoids empty-array + set -u)
while [ $# -gt 0 ]; do
  case "$1" in
    --values) VALUES_FILE="$2"; shift 2 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) FILTERS="${FILTERS} $1"; shift ;;
  esac
done

command -v helm >/dev/null || { echo "ERROR: helm not found on PATH" >&2; exit 3; }
command -v yq   >/dev/null || { echo "ERROR: yq (mikefarah v4+) not found on PATH" >&2; exit 3; }

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
RENDERED="${WORKDIR}/rendered.yaml"
APPS_NDJSON="${WORKDIR}/apps.ndjson"

echo "==> Rendering umbrella chart"
echo "    chart:  ${CHART_DIR}"
echo "    values: ${VALUES_FILE}"
helm template "$RELEASE" "$CHART_DIR" \
  --namespace "$NAMESPACE" \
  --values "$VALUES_FILE" \
  --include-crds > "$RENDERED"

# One compact JSON object per Application that installs a Helm chart (with or
# without inline values). Git-sourced Applications have no .spec.source.chart
# and are excluded here.
yq -o=json -I=0 -N '
  select(.kind == "Application")
  | select(.spec.source.chart != null)
  | {
      "name":    .metadata.name,
      "release": (.spec.source.helm.releaseName // .metadata.name),
      "chart":   .spec.source.chart,
      "repoURL": .spec.source.repoURL,
      "rev":     .spec.source.targetRevision,
      "values":  (.spec.source.helm.values // "")
    }
' "$RENDERED" > "$APPS_NDJSON"

matches_filter() {
  # no filters => match everything
  [ -z "${FILTERS// /}" ] && return 0
  local name="$1" f
  for f in $FILTERS; do
    case "$name" in *"$f"*) return 0 ;; esac
  done
  return 1
}

total=0; passed=0; failed=0; skipped=0; defaults=0
FAILED_NAMES=""

while IFS= read -r app; do
  [ -z "$app" ] && continue
  name=$(printf '%s' "$app"    | yq -p=json -r '.name')
  release=$(printf '%s' "$app" | yq -p=json -r '.release')
  chart=$(printf '%s' "$app"   | yq -p=json -r '.chart')
  repoURL=$(printf '%s' "$app" | yq -p=json -r '.repoURL')
  rev=$(printf '%s' "$app"     | yq -p=json -r '.rev')

  matches_filter "$name" || continue
  total=$((total + 1))

  # Only http(s) Helm repos are validated this way. Skip OCI / git sources.
  case "$repoURL" in
    http*) : ;;
    *) echo "SKIP  ${name}  (non-http repoURL: ${repoURL})"; skipped=$((skipped + 1)); continue ;;
  esac

  vals_content=$(printf '%s' "$app" | yq -p=json -r '.values')
  veropt=""
  [ "$rev" != "null" ] && [ -n "$rev" ] && veropt="--version $rev"

  # If the Application ships inline values, validate against them (-f). Otherwise
  # render with the chart's own defaults to confirm the chart/version resolves.
  fflag=""
  mode="defaults"
  if [ -n "$(printf '%s' "$vals_content" | tr -d '[:space:]')" ]; then
    vals="${WORKDIR}/${name}.values.yaml"
    printf '%s' "$vals_content" > "$vals"
    fflag="-f $vals"
    mode="values"
  else
    defaults=$((defaults + 1))
  fi

  errfile="${WORKDIR}/${name}.err"
  # shellcheck disable=SC2086
  if helm template "$release" "$chart" \
       --repo "$repoURL" $veropt \
       --namespace "$NAMESPACE" \
       $fflag > /dev/null 2> "$errfile"; then
    [ "$mode" = "defaults" ] && echo "PASS  ${name}  (${chart} ${rev}) (defaults)" || echo "PASS  ${name}  (${chart} ${rev})"
    passed=$((passed + 1))
  else
    echo "FAIL  ${name}  (${chart} ${rev}) [${mode}]"
    sed 's/^/        /' "$errfile"
    failed=$((failed + 1))
    FAILED_NAMES="${FAILED_NAMES} ${name}"
  fi
done < "$APPS_NDJSON"

echo
echo "==> Summary: ${total} validated (${defaults} via chart defaults), ${passed} passed, ${failed} failed, ${skipped} skipped"

# Zero matches is a failure, not a pass: it means the render produced no
# chart-sourced Applications, or the name filter(s) matched nothing. Either way
# nothing was actually validated, so don't let it look green.
if [ $total -eq 0 ]; then
  if [ -n "${FILTERS// /}" ]; then
    echo "ERROR: no Applications matched filter(s):${FILTERS}" >&2
  else
    echo "ERROR: no chart-sourced Applications found in the render" >&2
  fi
  exit 2
fi

if [ $failed -gt 0 ]; then
  echo "    failed:${FAILED_NAMES}"
  exit 1
fi
