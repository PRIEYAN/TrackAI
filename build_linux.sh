#!/bin/bash
set -e

cd "$(dirname "$0")"

# Clean build directory
rm -rf build/linux

# Run Flutter build with retry logic
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if flutter build linux --debug 2>&1 | tee /tmp/flutter_build.log; then
        echo "Build successful!"
        flutter run -d linux
        exit 0
    fi
    
    if grep -q "build.ninja still dirty" /tmp/flutter_build.log; then
        RETRY_COUNT=$((RETRY_COUNT + 1))
        echo "Build failed due to ninja dirty manifest, retrying ($RETRY_COUNT/$MAX_RETRIES)..."
        sleep 2
        rm -rf build/linux/x64/debug
        sync
    else
        echo "Build failed for a different reason"
        exit 1
    fi
done

echo "Build failed after $MAX_RETRIES retries"
exit 1

