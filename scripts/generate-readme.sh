#!/usr/bin/env bash
set -euo pipefail

CHARTS_DIR="./stable"
OUTPUT_FILE="README.md"
TEMP_FILE="$(mktemp)"

START_MARKER="<!-- START OF CHARTS SECTION -->"
END_MARKER="<!-- END OF CHARTS SECTION -->"

# Detect repo root if inside a git repo
if git rev-parse --show-toplevel >/dev/null 2>&1; then
  REPO_ROOT="$(git rev-parse --show-toplevel)"
else
  REPO_ROOT="$(pwd)"
fi

# Cross-platform helper for relative paths (works on macOS and Linux)
relpath() {
  python3 -c "import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))" "$1" "$2"
}

echo "Preserving static sections of README.md..."

if grep -q "$START_MARKER" "$OUTPUT_FILE" 2>/dev/null; then
  sed -n "1,/${START_MARKER}/p" "$OUTPUT_FILE" | sed '$d' >"$TEMP_FILE"
else
  cat "$OUTPUT_FILE" >"$TEMP_FILE"
fi

# Ensure a blank line before charts section
if [ -n "$(tail -n1 "$TEMP_FILE")" ]; then
  echo "" >>"$TEMP_FILE"
fi
echo "$START_MARKER" >>"$TEMP_FILE"
echo "Generating Helm chart information..."

# Loop through all charts
while IFS= read -r chart; do
  CHART_DIR="$(dirname "$chart")"
  CHART_NAME="$(yq e '.name' "$chart")"
  CHART_VERSION="$(yq e '.version' "$chart")"
  CHART_DESC="$(yq e '.description' "$chart")"
  REL_CHART_DIR="$(relpath "$CHART_DIR" "$REPO_ROOT")"

  {
    echo ""
    echo "## $CHART_NAME"
    echo "- **Version:** $CHART_VERSION"
    echo "- **Description:** $CHART_DESC"
    echo "- **Documentation:** [README](./$REL_CHART_DIR/README.md)"
  } >>"$TEMP_FILE"

  DEP_COUNT="$(yq e '.dependencies | length' "$chart" 2>/dev/null || echo 0)"
  if [[ "$DEP_COUNT" != "0" && "$DEP_COUNT" != "null" ]]; then
    echo "- **Dependencies:**" >>"$TEMP_FILE"

    # Iterate through dependencies
    for ((i = 0; i < DEP_COUNT; i++)); do
      DEP_NAME="$(yq e ".dependencies[$i].name" "$chart")"
      DEP_REPO="$(yq e ".dependencies[$i].repository" "$chart")"
      DEP_VER="$(yq e ".dependencies[$i].version" "$chart")"
      DEP_ABS_PATH=""
      DEP_REL_PATH=""

      # Detect local dependency path
      if [[ "$DEP_REPO" =~ ^file:// ]]; then
        DEP_PATH="${DEP_REPO#file://}"
        DEP_ABS_PATH="$(realpath "$CHART_DIR/$DEP_PATH" 2>/dev/null || true)"
      elif [ -d "$CHART_DIR/charts/$DEP_NAME" ]; then
        DEP_ABS_PATH="$(realpath "$CHART_DIR/charts/$DEP_NAME" 2>/dev/null || true)"
      fi

      if [[ -n "$DEP_ABS_PATH" && -f "$DEP_ABS_PATH/Chart.yaml" ]]; then
        LOCAL_VER="$(yq e '.version' "$DEP_ABS_PATH/Chart.yaml")"
        DEP_VER="$LOCAL_VER"
        DEP_REL_PATH="$(relpath "$DEP_ABS_PATH" "$REPO_ROOT")"

        if [ -f "$DEP_ABS_PATH/README.md" ]; then
          echo "  - [$DEP_NAME](./$DEP_REL_PATH/README.md) (local, version: $DEP_VER)" >>"$TEMP_FILE"
        else
          echo "  - $DEP_NAME (local, version: $DEP_VER)" >>"$TEMP_FILE"
        fi

        # List subdirectories under templates/ directly
        if [ -d "$DEP_ABS_PATH/templates" ]; then
          mapfile -t APP_DIRS < <(find "$DEP_ABS_PATH/templates" -mindepth 1 -maxdepth 1 -type d | sort)
          for app in "${APP_DIRS[@]}"; do
            APP_NAME="$(basename "$app")"
            APP_REL="$(relpath "$app" "$REPO_ROOT")"
            echo "    - [$APP_NAME](./$APP_REL)" >>"$TEMP_FILE"
          done
        fi
      else
        REPO_TEXT="${DEP_REPO:-null}"
        echo "  - $DEP_NAME ($REPO_TEXT, version: $DEP_VER)" >>"$TEMP_FILE"
      fi
    done
  fi
done < <(find "$CHARTS_DIR" -name "Chart.yaml" | sort)

echo "" >>"$TEMP_FILE"
echo "$END_MARKER" >>"$TEMP_FILE"

mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "README.md updated successfully!"
