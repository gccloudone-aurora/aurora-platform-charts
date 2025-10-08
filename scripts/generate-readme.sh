#!/bin/bash

# Define paths
CHARTS_DIR="./stable"
OUTPUT_FILE="README.md"
TEMP_FILE="README_TEMP.md"

START_MARKER="<!-- START OF CHARTS SECTION -->"
END_MARKER="<!-- END OF CHARTS SECTION -->"

# Step 1: Backup the original README into a temp file
echo "Preserving static sections of README.md..."

# Check if START_MARKER and END_MARKER exist in README.md
if grep -q "$START_MARKER" "$OUTPUT_FILE"; then
  # Extract the content above the START_MARKER
  sed -n "1,/${START_MARKER}/p" "$OUTPUT_FILE" | sed '$d' > "$TEMP_FILE"
else
  # Fallback: Copy existing README as is to TEMP_FILE if START_MARKER not found
  cat "$OUTPUT_FILE" > "$TEMP_FILE"
fi

# Step 2: Ensure a single blank line exists before the START_MARKER
LAST_LINE=$(tail -n 1 "$TEMP_FILE")
if [ "$LAST_LINE" != "" ]; then
  echo "" >> "$TEMP_FILE"
fi
echo "$START_MARKER" >> "$TEMP_FILE"

# Step 3: Append dynamically generated chart details
echo "Generating Helm chart information..."
for chart in $(find "$CHARTS_DIR" -name "Chart.yaml" | sort); do
  CHART_DIR=$(dirname "$chart")
  CHART_NAME=$(yq e '.name' "$chart")
  CHART_VERSION=$(yq e '.version' "$chart")
  CHART_DESC=$(yq e '.description' "$chart")

  # Append chart information into the README
  echo "" >> "$TEMP_FILE"
  echo "## $CHART_NAME" >> "$TEMP_FILE"
  echo "- **Version:** $CHART_VERSION" >> "$TEMP_FILE"
  echo "- **Description:** $CHART_DESC" >> "$TEMP_FILE"
  echo "- **Documentation:** [README]($CHART_DIR/README.md)" >> "$TEMP_FILE"
done

# Step 4: Ensure a single blank line exists before the END_MARKER
echo "" >> "$TEMP_FILE"
echo "$END_MARKER" >> "$TEMP_FILE"

# Step 5: Replace the original README.md with the updated content
mv "$TEMP_FILE" "$OUTPUT_FILE"
echo "README.md updated successfully!"
