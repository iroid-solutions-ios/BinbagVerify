#!/bin/bash

# Build XCFramework Script for BinbagVerifyPackage
# This creates a binary framework that hides source code

set -e

PACKAGE_NAME="BinbagVerifyPackage"
FRAMEWORK_NAME="BinbagVerifyPackage"
PROJECT_DIR="$(dirname "$(pwd)")"
BUILD_DIR="$(pwd)/build"
XCFRAMEWORK_OUTPUT="$(pwd)/${FRAMEWORK_NAME}.xcframework"
DERIVED_DATA_DEVICE="$(pwd)/DerivedData-Device"
DERIVED_DATA_SIM="$(pwd)/DerivedData-Simulator"

echo "=========================================="
echo "  Building BinbagVerify XCFramework"
echo "=========================================="
echo ""
echo "Project directory: $PROJECT_DIR"
echo ""

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf "$BUILD_DIR"
rm -rf "$XCFRAMEWORK_OUTPUT"
rm -rf "$DERIVED_DATA_DEVICE"
rm -rf "$DERIVED_DATA_SIM"
mkdir -p "$BUILD_DIR"

# Temporarily change Package.swift to dynamic library for XCFramework build
echo "Setting library type to dynamic for XCFramework build..."
PACKAGE_SWIFT="$(pwd)/Package.swift"
cp "$PACKAGE_SWIFT" "$PACKAGE_SWIFT.backup"

# Create dynamic version of Package.swift
cat > "$PACKAGE_SWIFT" << 'PACKAGEEOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BinbagVerifyPackage",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BinbagVerifyPackage",
            type: .dynamic,
            targets: ["BinbagVerifyPackage"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0")
    ],
    targets: [
        .target(
            name: "BinbagVerifyPackage",
            dependencies: [
                "Alamofire"
            ],
            path: "Sources/BinbagVerifyPackage",
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
PACKAGEEOF

# Function to restore Package.swift
restore_package() {
    if [ -f "$PACKAGE_SWIFT.backup" ]; then
        mv "$PACKAGE_SWIFT.backup" "$PACKAGE_SWIFT"
        echo "Restored Package.swift to static library"
    fi
}

# Restore on exit (including on error)
trap restore_package EXIT

# Build for iOS Device
echo ""
echo "Building for iOS Device (arm64)..."
xcodebuild archive \
    -project "$PROJECT_DIR/BinbagVerify.xcodeproj" \
    -scheme "$PACKAGE_NAME" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "$BUILD_DIR/iOS-Device" \
    -derivedDataPath "$DERIVED_DATA_DEVICE" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SWIFT_EMIT_MODULE_INTERFACE=YES \
    OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
    2>&1 | tee "$BUILD_DIR/device_build.log" | grep -E "(error:|warning:.*error|BUILD|Linking|Compiling)" | head -30

DEVICE_BUILD_RESULT=${PIPESTATUS[0]}
if [ $DEVICE_BUILD_RESULT -ne 0 ]; then
    echo ""
    echo "ERROR: Device build failed. Check $BUILD_DIR/device_build.log for details."
    tail -50 "$BUILD_DIR/device_build.log"
    exit 1
fi

# Build for iOS Simulator
echo ""
echo "Building for iOS Simulator..."
xcodebuild archive \
    -project "$PROJECT_DIR/BinbagVerify.xcodeproj" \
    -scheme "$PACKAGE_NAME" \
    -configuration Release \
    -destination "generic/platform=iOS Simulator" \
    -archivePath "$BUILD_DIR/iOS-Simulator" \
    -derivedDataPath "$DERIVED_DATA_SIM" \
    SKIP_INSTALL=NO \
    BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
    SWIFT_EMIT_MODULE_INTERFACE=YES \
    OTHER_SWIFT_FLAGS="-no-verify-emitted-module-interface" \
    2>&1 | tee "$BUILD_DIR/simulator_build.log" | grep -E "(error:|warning:.*error|BUILD|Linking|Compiling)" | head -30

SIM_BUILD_RESULT=${PIPESTATUS[0]}
if [ $SIM_BUILD_RESULT -ne 0 ]; then
    echo ""
    echo "ERROR: Simulator build failed. Check $BUILD_DIR/simulator_build.log for details."
    tail -50 "$BUILD_DIR/simulator_build.log"
    exit 1
fi

# Find the built frameworks
echo ""
echo "Locating built frameworks..."

DEVICE_FRAMEWORK=$(find "$BUILD_DIR/iOS-Device.xcarchive" -name "${FRAMEWORK_NAME}.framework" -type d 2>/dev/null | head -1)
SIM_FRAMEWORK=$(find "$BUILD_DIR/iOS-Simulator.xcarchive" -name "${FRAMEWORK_NAME}.framework" -type d 2>/dev/null | head -1)

echo "Device framework: $DEVICE_FRAMEWORK"
echo "Simulator framework: $SIM_FRAMEWORK"

# Check for swiftmodule
echo ""
echo "Checking for Swift interface files..."
find "$BUILD_DIR" -name "*.swiftinterface" -type f 2>/dev/null | head -5
find "$BUILD_DIR" -name "*.swiftmodule" -type d 2>/dev/null | head -5

# If frameworks not found in standard location, search in Products
if [ -z "$DEVICE_FRAMEWORK" ] || [ -z "$SIM_FRAMEWORK" ]; then
    echo ""
    echo "Framework not found in standard location, searching archive..."

    # Try to find in different locations
    DEVICE_FRAMEWORK=$(find "$BUILD_DIR/iOS-Device.xcarchive/Products" -name "*.framework" -type d 2>/dev/null | grep -i "$FRAMEWORK_NAME" | head -1)
    SIM_FRAMEWORK=$(find "$BUILD_DIR/iOS-Simulator.xcarchive/Products" -name "*.framework" -type d 2>/dev/null | grep -i "$FRAMEWORK_NAME" | head -1)

    echo "Device framework (search 2): $DEVICE_FRAMEWORK"
    echo "Simulator framework (search 2): $SIM_FRAMEWORK"
fi

# If still not found, we need to create framework from the dylib
if [ -z "$DEVICE_FRAMEWORK" ] || [ -z "$SIM_FRAMEWORK" ]; then
    echo ""
    echo "Creating framework structure from build products..."

    # Find the dylib or binary
    DEVICE_BINARY=$(find "$BUILD_DIR/iOS-Device.xcarchive" -name "lib${PACKAGE_NAME}.dylib" -o -name "${PACKAGE_NAME}" -type f 2>/dev/null | grep -v ".dSYM" | head -1)
    SIM_BINARY=$(find "$BUILD_DIR/iOS-Simulator.xcarchive" -name "lib${PACKAGE_NAME}.dylib" -o -name "${PACKAGE_NAME}" -type f 2>/dev/null | grep -v ".dSYM" | head -1)

    if [ -z "$DEVICE_BINARY" ]; then
        DEVICE_BINARY=$(find "$BUILD_DIR/iOS-Device.xcarchive" -name "${PACKAGE_NAME}.framework" -type d 2>/dev/null | head -1)
        if [ -n "$DEVICE_BINARY" ]; then
            DEVICE_BINARY="$DEVICE_BINARY/${PACKAGE_NAME}"
        fi
    fi

    if [ -z "$SIM_BINARY" ]; then
        SIM_BINARY=$(find "$BUILD_DIR/iOS-Simulator.xcarchive" -name "${PACKAGE_NAME}.framework" -type d 2>/dev/null | head -1)
        if [ -n "$SIM_BINARY" ]; then
            SIM_BINARY="$SIM_BINARY/${PACKAGE_NAME}"
        fi
    fi

    echo "Device binary: $DEVICE_BINARY"
    echo "Simulator binary: $SIM_BINARY"

    if [ -n "$DEVICE_BINARY" ] && [ -n "$SIM_BINARY" ]; then
        # Create framework directories
        DEVICE_FW_DIR="$BUILD_DIR/frameworks/ios-arm64/${FRAMEWORK_NAME}.framework"
        SIM_FW_DIR="$BUILD_DIR/frameworks/ios-arm64_x86_64-simulator/${FRAMEWORK_NAME}.framework"

        mkdir -p "$DEVICE_FW_DIR/Modules/${FRAMEWORK_NAME}.swiftmodule"
        mkdir -p "$SIM_FW_DIR/Modules/${FRAMEWORK_NAME}.swiftmodule"

        # Copy binaries
        cp "$DEVICE_BINARY" "$DEVICE_FW_DIR/${FRAMEWORK_NAME}"
        cp "$SIM_BINARY" "$SIM_FW_DIR/${FRAMEWORK_NAME}"

        # Find and copy swiftmodule files
        DEVICE_SWIFTMODULE=$(find "$BUILD_DIR/iOS-Device.xcarchive" -path "*/${FRAMEWORK_NAME}.swiftmodule" -type d 2>/dev/null | head -1)
        SIM_SWIFTMODULE=$(find "$BUILD_DIR/iOS-Simulator.xcarchive" -path "*/${FRAMEWORK_NAME}.swiftmodule" -type d 2>/dev/null | head -1)

        # Also check in DerivedData
        if [ -z "$DEVICE_SWIFTMODULE" ]; then
            DEVICE_SWIFTMODULE=$(find "$DERIVED_DATA_DEVICE" -path "*/${FRAMEWORK_NAME}.swiftmodule" -type d 2>/dev/null | head -1)
        fi
        if [ -z "$SIM_SWIFTMODULE" ]; then
            SIM_SWIFTMODULE=$(find "$DERIVED_DATA_SIM" -path "*/${FRAMEWORK_NAME}.swiftmodule" -type d 2>/dev/null | head -1)
        fi

        echo "Device swiftmodule: $DEVICE_SWIFTMODULE"
        echo "Simulator swiftmodule: $SIM_SWIFTMODULE"

        if [ -n "$DEVICE_SWIFTMODULE" ]; then
            cp -R "$DEVICE_SWIFTMODULE"/* "$DEVICE_FW_DIR/Modules/${FRAMEWORK_NAME}.swiftmodule/" 2>/dev/null || true
        fi

        if [ -n "$SIM_SWIFTMODULE" ]; then
            cp -R "$SIM_SWIFTMODULE"/* "$SIM_FW_DIR/Modules/${FRAMEWORK_NAME}.swiftmodule/" 2>/dev/null || true
        fi

        # Create module.modulemap
        cat > "$DEVICE_FW_DIR/Modules/module.modulemap" << EOF
framework module ${FRAMEWORK_NAME} {
    header "${FRAMEWORK_NAME}-Swift.h"
    export *
}
EOF
        cp "$DEVICE_FW_DIR/Modules/module.modulemap" "$SIM_FW_DIR/Modules/module.modulemap"

        # Find and copy Swift header
        DEVICE_HEADER=$(find "$DERIVED_DATA_DEVICE" -name "${FRAMEWORK_NAME}-Swift.h" 2>/dev/null | head -1)
        SIM_HEADER=$(find "$DERIVED_DATA_SIM" -name "${FRAMEWORK_NAME}-Swift.h" 2>/dev/null | head -1)

        echo "Device header: $DEVICE_HEADER"
        echo "Simulator header: $SIM_HEADER"

        mkdir -p "$DEVICE_FW_DIR/Headers"
        mkdir -p "$SIM_FW_DIR/Headers"

        if [ -n "$DEVICE_HEADER" ]; then
            cp "$DEVICE_HEADER" "$DEVICE_FW_DIR/Headers/"
        fi
        if [ -n "$SIM_HEADER" ]; then
            cp "$SIM_HEADER" "$SIM_FW_DIR/Headers/"
        fi

        # Create Info.plist
        cat > "$DEVICE_FW_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>${FRAMEWORK_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.binbag.verify</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>${FRAMEWORK_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>MinimumOSVersion</key>
    <string>13.0</string>
</dict>
</plist>
EOF
        cp "$DEVICE_FW_DIR/Info.plist" "$SIM_FW_DIR/Info.plist"

        DEVICE_FRAMEWORK="$DEVICE_FW_DIR"
        SIM_FRAMEWORK="$SIM_FW_DIR"
    fi
fi

if [ -z "$DEVICE_FRAMEWORK" ] || [ -z "$SIM_FRAMEWORK" ]; then
    echo ""
    echo "ERROR: Could not find or create frameworks!"
    echo ""
    echo "Archive contents:"
    find "$BUILD_DIR" -type f -name "*.framework" -o -name "*.dylib" -o -name "${PACKAGE_NAME}" 2>/dev/null | head -30
    exit 1
fi

echo ""
echo "Final frameworks:"
echo "  Device: $DEVICE_FRAMEWORK"
echo "  Simulator: $SIM_FRAMEWORK"

# Show framework contents
echo ""
echo "Device framework contents:"
ls -la "$DEVICE_FRAMEWORK/"
if [ -d "$DEVICE_FRAMEWORK/Modules" ]; then
    echo "Modules:"
    ls -la "$DEVICE_FRAMEWORK/Modules/"
fi

# Create XCFramework
echo ""
echo "Creating XCFramework..."
xcodebuild -create-xcframework \
    -framework "$DEVICE_FRAMEWORK" \
    -framework "$SIM_FRAMEWORK" \
    -output "$XCFRAMEWORK_OUTPUT"

# Copy swiftmodule files to XCFramework
echo ""
echo "Copying Swift interface files..."

DEVICE_SWIFTMODULE_SRC=$(find "$DERIVED_DATA_DEVICE" -name "${FRAMEWORK_NAME}.swiftmodule" -type d 2>/dev/null | head -1)
SIM_SWIFTMODULE_SRC=$(find "$DERIVED_DATA_SIM" -name "${FRAMEWORK_NAME}.swiftmodule" -type d 2>/dev/null | head -1)

if [ -n "$DEVICE_SWIFTMODULE_SRC" ]; then
    mkdir -p "$XCFRAMEWORK_OUTPUT/ios-arm64/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"
    cp -R "$DEVICE_SWIFTMODULE_SRC"/* "$XCFRAMEWORK_OUTPUT/ios-arm64/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/"
    echo "Copied device Swift interface files"
fi

if [ -n "$SIM_SWIFTMODULE_SRC" ]; then
    mkdir -p "$XCFRAMEWORK_OUTPUT/ios-arm64_x86_64-simulator/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule"
    cp -R "$SIM_SWIFTMODULE_SRC"/* "$XCFRAMEWORK_OUTPUT/ios-arm64_x86_64-simulator/${FRAMEWORK_NAME}.framework/Modules/${FRAMEWORK_NAME}.swiftmodule/"
    echo "Copied simulator Swift interface files"
fi

# Find and copy resources bundle
echo ""
echo "Looking for resources bundle..."
RESOURCES_BUNDLE=$(find "$DERIVED_DATA_DEVICE" -name "*${PACKAGE_NAME}.bundle" -type d 2>/dev/null | head -1)
if [ -z "$RESOURCES_BUNDLE" ]; then
    RESOURCES_BUNDLE=$(find "$DERIVED_DATA_SIM" -name "*${PACKAGE_NAME}.bundle" -type d 2>/dev/null | head -1)
fi
if [ -z "$RESOURCES_BUNDLE" ]; then
    RESOURCES_BUNDLE=$(find "$BUILD_DIR" -name "*${PACKAGE_NAME}.bundle" -type d 2>/dev/null | head -1)
fi

if [ -n "$RESOURCES_BUNDLE" ]; then
    echo "Found resources bundle: $RESOURCES_BUNDLE"
    BUNDLE_NAME=$(basename "$RESOURCES_BUNDLE")
    cp -R "$RESOURCES_BUNDLE" "$(dirname "$XCFRAMEWORK_OUTPUT")/"
    echo "Copied to: $(dirname "$XCFRAMEWORK_OUTPUT")/$BUNDLE_NAME"
else
    echo "No resources bundle found."
fi

echo ""
echo "=========================================="
echo "  BUILD SUCCESSFUL!"
echo "=========================================="
echo ""
echo "XCFramework location:"
echo "  $XCFRAMEWORK_OUTPUT"
echo ""
echo "XCFramework contents:"
find "$XCFRAMEWORK_OUTPUT" -type f | head -20
echo ""
echo "To use in another project:"
echo "  1. Drag ${FRAMEWORK_NAME}.xcframework into Xcode"
echo "  2. Add to 'Frameworks, Libraries, and Embedded Content'"
echo "  3. Select 'Embed & Sign'"
if [ -n "$RESOURCES_BUNDLE" ]; then
    echo "  4. Also add the resources bundle: $BUNDLE_NAME"
fi
echo ""
