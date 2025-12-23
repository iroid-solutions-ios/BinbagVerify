# BinbagVerify SDK

A Swift Package for document verification and identity validation.

## Installation

### Swift Package Manager

Add the following to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/YourOrg/BinbagVerifyPackage.git", from: "1.0.0")
]
```

Or in Xcode:
1. Go to **File > Add Packages...**
2. Enter the repository URL
3. Select version and add to your project

## Setup

### 1. Configure the SDK

In your `AppDelegate` or `App` struct, configure the SDK with your API key:

```swift
import BinbagVerifyPackage

// In AppDelegate
func application(_ application: UIApplication, didFinishLaunchingWithOptions...) -> Bool {
    BinbagVerify.configure(with: BinbagVerifyConfig(
        apiKey: "YOUR_API_KEY",
        environment: .production  // or .development, .staging
    ))
    return true
}

// Or in SwiftUI App
@main
struct MyApp: App {
    init() {
        BinbagVerify.configure(with: BinbagVerifyConfig(
            apiKey: "YOUR_API_KEY",
            environment: .production
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### 2. Add Required Permissions

Add these keys to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for document scanning and face verification</string>
```

## Usage

### UIKit

```swift
import BinbagVerifyPackage

class ViewController: UIViewController {

    @IBAction func verifyTapped(_ sender: Any) {
        // Option 1: Using the convenience extension
        presentBinbagVerification(type: .fullVerification) { result in
            if result.isVerified {
                print("Verification successful!")
                if let document = result.documentData?.diveResponse?.document {
                    print("Name: \(document.fullName ?? "N/A")")
                }
            } else if let error = result.error {
                print("Verification failed: \(error.localizedDescription)")
            }
        }

        // Option 2: Using the shared instance
        BinbagVerify.shared.startVerification(
            from: self,
            type: .documentOnly,
            completion: { result in
                // Handle result
            }
        )
    }

    // For re-verification (existing users)
    @IBAction func reverifyTapped(_ sender: Any) {
        presentBinbagVerification(
            type: .reverification,
            userEmail: "user@example.com"
        ) { result in
            // Handle result
        }
    }
}
```

### SwiftUI

```swift
import SwiftUI
import BinbagVerifyPackage

struct ContentView: View {
    @State private var showVerification = false
    @State private var verificationResult: BinbagVerificationResult?

    var body: some View {
        VStack {
            // Option 1: Using the view modifier
            Button("Verify Identity") {
                showVerification = true
            }
            .binbagVerify(
                isPresented: $showVerification,
                type: .fullVerification
            ) { result in
                verificationResult = result
                handleResult(result)
            }

            // Option 2: Using the pre-built button
            BinbagVerifyButton(
                title: "Start Verification",
                verificationType: .documentOnly
            ) { result in
                handleResult(result)
            }

            // Show result
            if let result = verificationResult, result.isVerified {
                Text("Verified!")
                    .foregroundColor(.green)
            }
        }
    }

    private func handleResult(_ result: BinbagVerificationResult) {
        if result.isVerified {
            // Handle success
            if let doc = result.documentData?.diveResponse?.document {
                print("Verified: \(doc.fullName ?? "")")
            }
        } else if let error = result.error {
            // Handle error
            print("Error: \(error.localizedDescription)")
        }
    }
}
```

## Verification Types

| Type | Description |
|------|-------------|
| `.fullVerification` | Complete flow: Sign up + Document capture + Face verification |
| `.documentOnly` | Document capture + Face verification (no sign up) |
| `.reverification` | Face-only verification for existing users |

## Verification Result

The `BinbagVerificationResult` contains:

```swift
struct BinbagVerificationResult {
    let isVerified: Bool
    let documentData: DocumentVerificationData?
    let error: BinbagVerifyError?
}
```

### Accessing Document Data

```swift
if let diveResponse = result.documentData?.diveResponse {
    // Document info
    let document = diveResponse.document
    print("Full Name: \(document?.fullName ?? "")")
    print("DOB: \(document?.dob ?? "")")
    print("Address: \(document?.address ?? "")")
    print("ID Number: \(document?.id ?? "")")

    // Verification results
    let docResult = diveResponse.documentVerificationResult
    print("Document Expired: \(docResult?.isDocumentExpired ?? false)")

    // Face match
    let faceResult = diveResponse.faceMatchVerificationResult
    print("Face Match Confidence: \(faceResult?.faceMatchConfidence ?? 0)")
}
```

## Error Handling

```swift
switch result.error {
case .notConfigured:
    print("SDK not configured. Call BinbagVerify.configure() first.")
case .userCancelled:
    print("User cancelled verification")
case .verificationFailed(let message):
    print("Verification failed: \(message)")
case .networkError(let message):
    print("Network error: \(message)")
case .cameraAccessDenied:
    print("Camera access denied")
case .invalidDocument:
    print("Invalid document")
case .none:
    break
}
```

## Supported Document Types

- Driver's License or ID Card
- Passport
- Passport Card
- International ID

## Requirements

- iOS 13.0+
- Swift 5.9+
- Xcode 15.0+

## License

Copyright (c) Binbag. All rights reserved.
