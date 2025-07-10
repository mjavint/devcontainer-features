#!/bin/bash

set -e

# Import test utils
source dev-container-features-test-lib

# Feature name for the test
FEATURE_NAME="wkhtmltopdf"

# Test version command
check "version" wkhtmltopdf --version

# Test PDF generation functionality
echo "<h1>Test PDF</h1>" > test.html
check "generate pdf" bash -c "wkhtmltopdf test.html test.pdf && [ -f test.pdf ]"

# Clean up test files
rm -f test.html test.pdf

# Report result
reportResults
