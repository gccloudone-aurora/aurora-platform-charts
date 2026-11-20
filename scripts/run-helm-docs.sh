#!/usr/bin/env bash
set -euo pipefail

echo "🧾 Running helm-docs recursively across all charts..."

# Detect all Chart.yaml files and run helm-docs in their directory
find ./stable -type f -name "Chart.yaml" ! -path "*/charts/*/charts/*" | while read -r chart; do
  CHART_DIR=$(dirname "$chart")
  echo "📦 Generating docs for: $CHART_DIR"
  (cd "$CHART_DIR" && helm-docs --chart-search-root .)
done

echo "✅ All Helm chart READMEs updated."
