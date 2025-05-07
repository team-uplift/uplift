#!/usr/bin/env bash
set -euo pipefail

# Where coverage files go
COV_DIR=coverage
COMBINED="${COV_DIR}/lcov_combined.info"

# Make sure the coverage directory exists and is empty
rm -rf "$COV_DIR"
mkdir -p "$COV_DIR"

# List here each test directory or file pattern you want to cover:
TEST_TARGETS=(
    "test/api"
    "test/components"
    "test/constants"
    "test/models"
    "test/recipients"
    "test/screens/auth"
    "test/screens/home"
    "test/screens/recipient_reg_screens"
    "test/services"
    "test/utils"
    # add more as-needed...
)

# Run each suite, emitting its own lcov.info under coverage/
for target in "${TEST_TARGETS[@]}"; do
  # sanitize name to use in filename
  NAME=$(echo "$target" | tr '/ ' '__')
  echo "👉 running flutter test --coverage ($target)..."
  flutter test \
    --coverage \
    --coverage-path="$COV_DIR/lcov_${NAME}.info" \
    "$target"
done

# Now combine them all into one lcov
echo "👉 merging all lcov files into $COMBINED"
# initialize with the first one
FIRST="${COV_DIR}/lcov_$(echo "${TEST_TARGETS[0]}" | tr '/ ' '__').info"
cp "$FIRST" "$COMBINED"

# then add the rest
for idx in "${!TEST_TARGETS[@]}"; do
  if [ "$idx" -eq 0 ]; then continue; fi
  f="$COV_DIR/lcov_$(echo "${TEST_TARGETS[$idx]}" | tr '/ ' '__').info"
  lcov --add-tracefile "$COMBINED" --add-tracefile "$f" \
       --output-file "$COMBINED"
done

# Optional: generate html report
if command -v genhtml >/dev/null; then
  echo "👉 generating HTML report under coverage/html"
  mkdir -p "$COV_DIR/html"
  genhtml -o "$COV_DIR/html" "$COMBINED"
  echo "Open coverage/html/index.html in your browser to view it."
fi

echo "🎉 All done! Combined coverage at $COMBINED"
