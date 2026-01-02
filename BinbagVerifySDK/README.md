# BinbagVerify SDK

Identity verification SDK for iOS apps. **Source code is hidden** - distributed as binary framework.

## Installation (Swift Package Manager)

### Option 1: From GitHub URL (Recommended)

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter: `https://github.com/iroid-solutions-ios/BinbagVerify.git`
3. Select version `1.0.1` and **BinbagVerifyPackage** library

### Option 2: Local Package

1. Copy the `BinbagVerifySDK` folder to your project
2. In Xcode, go to **File → Add Package Dependencies**
3. Click **Add Local** and select the folder

## Setup

### 1. Configure SDK (AppDelegate)

```swift
import BinbagVerifyPackage

func application(_ application: UIApplication, didFinishLaunchingWithOptions...) -> Bool {
    BinbagVerify.configure(with: BinbagVerifyConfig(
        apiKey: "YOUR_API_KEY",
        environment: .production,
        primaryColor: .systemBlue  // optional
    ))
    return true
}
```

### 2. Add Camera Permission (Info.plist)

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for document and face verification</string>
```

## Usage

### Document Scan (ID + Face Verification)

```swift
import BinbagVerifyPackage

let userEmail = "user@example.com"

// Option 1: Static method (auto-finds top view controller)
BinbagVerify.startDocumentScan(email: userEmail) { result in
    if result.isVerified {
        if let doc = result.documentData?.diveResponse?.document {
            print("Verified! Name: \(doc.fullName ?? "")")
        }
    } else if let error = result.error {
        print("Error: \(error.localizedDescription)")
    }
}

// Option 2: From a UIViewController
presentBinbagDocumentScan(email: userEmail) { result in
    // Handle result
}
```

### Face Detection Only (Reverification)

```swift
let userEmail = "user@example.com"

// Option 1: Static method (email is required)
BinbagVerify.startFaceDetection(email: userEmail) { result in
    if result.isVerified {
        print("Face verified!")
    }
}

// Option 2: From a UIViewController
presentBinbagFaceDetection(email: userEmail) { result in
    // Handle result
}
```

### SwiftUI

```swift
import SwiftUI
import BinbagVerifyPackage

struct ContentView: View {
    @State private var showScan = false
    let userEmail = "user@example.com"

    var body: some View {
        VStack {
            // Option 1: View modifier
            Button("Document Scan") { showScan = true }
                .binbagDocumentScan(isPresented: $showScan, email: userEmail) { result in
                    // Handle result
                }

            // Option 2: Pre-built button
            BinbagVerifyButton(
                title: "Verify Identity",
                verificationType: .documentScan,
                email: userEmail
            ) { result in
                // Handle result
            }

            // Option 3: Manager-based (for triggering from anywhere)
            Button("Face Detection") {
                BinbagVerifyManager.shared.startFaceDetection(email: userEmail) { result in
                    // Handle result
                }
            }
        }
        .binbagVerifyEnabled()  // Required for BinbagVerifyManager
    }
}
```

## Verification Types

| Type | Description |
|------|-------------|
| `.documentScan` | Document capture + Face verification |
| `.faceDetection` | Face-only verification (for reverification) |

## Requirements

- iOS 13.0+ (iOS 14.0+ for SwiftUI features)
- Xcode 15.0+
- Swift 5.9+

---

## For SDK Developers: Hosting Instructions

### Step 1: Create the XCFramework zip

```bash
cd BinbagVerifySDK
zip -r BinbagVerifyPackage.xcframework.zip BinbagVerifyPackage.xcframework
```

### Step 2: Get checksum

```bash
swift package compute-checksum BinbagVerifyPackage.xcframework.zip
```

### Step 3: Host the zip file

**Option A: GitHub Releases**
1. Create a new GitHub repo for the SDK
2. Push the `BinbagVerifySDK` folder (without xcframework)
3. Create a Release and attach the `.zip` file
4. Update `Package.swift` with the release URL and checksum

**Option B: Your own server**
1. Upload `.zip` to your server (HTTPS required)
2. Update `Package.swift` with URL and checksum

### Step 4: Update Package.swift

```swift
// Comment out OPTION 1 (local path)
// Uncomment OPTION 2 and fill in:
.binaryTarget(
    name: "BinbagVerifyPackage",
    url: "https://github.com/YOUR_ORG/BinbagVerifySDK/releases/download/v1.0.0/BinbagVerifyPackage.xcframework.zip",
    checksum: "abc123..."  // from Step 2
),
```

### What Users See vs Cannot See

| Users CAN see | Users CANNOT see |
|---------------|------------------|
| Public class names | Implementation code |
| Public function signatures | Private functions |
| API documentation | Business logic |
| `.swiftinterface` files | `.swift` source files |
