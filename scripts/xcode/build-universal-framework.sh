#!/bin/sh
# Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
#
# You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
# copy, modify, and distribute this software in source code or binary form for use
# in connection with the web services and APIs provided by Facebook.
#
# As with any software that integrates with the Facebook platform, your use of
# this software is subject to the Facebook Developer Principles and Policies
# [http://developers.facebook.com/policy/]. This copyright notice shall be
# included in all copies or substantial portions of the software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# --------------
# Main Script
# --------------

# shellcheck disable=SC1091
# shellcheck source=exclude-architectures.sh
. "${SOURCE_ROOT}/../scripts/exclude-architectures.sh"

UNIVERSAL_BUILD_FOLDER=../build/

# make the output directory and delete the framework directory
mkdir -p "${UNIVERSAL_BUILD_FOLDER}"
rm -rf "${UNIVERSAL_BUILD_FOLDER}/${PRODUCT_NAME}.framework"

# get target by removing '-Universal' from $TARGET_NAME and adding '-Static'
TARGET=${TARGET_NAME%-Universal}-Static

# Step 1. Build Simulator version
xcodebuild -target "${TARGET}" \
  ONLY_ACTIVE_ARCH=NO \
  -configuration "${CONFIGURATION}" \
  -sdk iphonesimulator \
  BUILD_DIR="${BUILD_DIR}" \
  BUILD_ROOT="${BUILD_ROOT}" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO

# Step 2. Copy the framework structure to the universal folder
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PRODUCT_NAME}.framework" "${UNIVERSAL_BUILD_FOLDER}/"
