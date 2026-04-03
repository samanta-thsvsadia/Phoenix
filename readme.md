# Phoenix 
### **Real-time ASL Translation & Social Connectivity Platform**

[![Platform](https://img.shields.io/badge/Platform-iOS_16.0+-black?style=for-the-badge&logo=ios)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=for-the-badge&logo=swift)](https://swift.org)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=for-the-badge)](https://choosealicense.com/no-permission/)

**Phoenix** is an iOS application designed to bridge the communication gap for the Deaf and Hard-of-Hearing community. It features a custom machine learning pipeline for real-time American Sign Language (ASL) translation integrated into a high-performance social networking engine.

This application was live on the App Store from 12/24 to 01/26

---

## App Media
| Live Camera | Image Detection |
| :---: | :---: |
| <img src="link" width="280" alt="ML Translation Demo"> | <img src="link" width="280" alt="Social Feed Demo"> |
| *Real-time inference at 30fps* | *Post creation and community feed* |

---

## Code Overview

### High-Performance ML Pipeline
The core of Phoenix is a computer vision pipeline built on Vision and CoreML:
* **Hand Pose Estimation:** Leverages `VNDetectHumanHandPoseRequest` to track 21 distinct landmarks on the user's hand.
* **Inference Engine:** A custom-trained model capable of recognizing the ASL alphabet with high precision, optimized for on-device processing to ensure user privacy and zero latency.
* **Buffer Management:** Implements advanced `CVPixelBuffer` and `CGImage` extensions for seamless frame conversion between the camera and the ML model.

### App Architecture
* **Pattern:** MVVM (Model-View-ViewModel) for clean separation of concerns.
* **Reactive UI:** Built entirely with SwiftUI and Combine to handle asynchronous data streams from the camera hardware.
* **Hardware Interfacing:** AVFoundation wrapper manages the capture session, orientation, and permission handling.

---

### [Core Logic & Hardware](/PhoenixApp/ASL%20Translator)
* **`CameraManager.swift`**: Handles the `AVCaptureSession` lifecycle, thread-safe camera queuing, and permission states.
* **`FrameManager.swift`**: Acts as the delegate for `AVCaptureVideoDataOutput`, piping buffers into the UI stream.
* **`ContentViewModel.swift`**: The "Brain" of the view—managing subscriptions via Combine and applying real-time CIImage filters.

### [UI Components](/PhoenixApp/ASL%20Translator)
* **`CameraView.swift`**: SwiftUI implementation that overlays ML predictions on top of live video feeds. (Precitions are only shown on developer mode)
* **`Extensions`**: Image resizing and pixel buffer utilities used to prepare data for the Vision framework.

---

#### 1. Camera Configuration
The `CameraManager` handles the setup of the `AVCaptureSession` and ensures the app has the necessary permissions to access the front-facing camera.

```swift
private func configureCaptureSession() {
    guard status == .unconfigured else { return }
    session.beginConfiguration()
    defer { session.commitConfiguration() }
    
    let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    guard let camera = device else {
        set(error: .cameraUnavailable)
        status = .failed
        return
    }
    // ... adds input and output to session
}
```



---

#### 2. Image Conversion for ML

Custom extensions handle the conversion of `UIImage` to `CVPixelBuffer`, ensuring the data is in the correct format (`kCVPixelFormatType_32ARGB`) for the machine learning model.

```swift
private func configureCaptureSession() {
    guard status == .unconfigured else { return }
    session.beginConfiguration()
    defer { session.commitConfiguration() }
    
    let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    guard let camera = device else {
        set(error: .cameraUnavailable)
        status = .failed
        return
    }
    // ... adds input and output to session
}
```



---

## Security & Copyright
**Copyright © 2026 Sadia Thasina Samanta. All rights reserved.**

This repository is for **portfolio review purposes only**. No part of this program may be redistributed or used for commercial purposes.

---
**Developer:** sam.thsv7@gmail.com | https://www.linkedin.com/in/sadia-thasina-8392a637b
