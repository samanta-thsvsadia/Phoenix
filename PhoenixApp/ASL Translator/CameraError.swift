
import Foundation

enum CameraError: Error {
    case cameraUnavailable
    case cannotAddInput
    case cannotAddOutput
    case createCaptureInput(Error)
    case deniedAuthorization
    case restrictedAuthorization
    case unknownAuthorization
}

extension CameraError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .cameraUnavailable:
            return "The Camera is unavailable"
        case .cannotAddInput:
            return "Failed to add capture input to session"
        case .cannotAddOutput:
            return "Failed to add video output to session"
        case .createCaptureInput(let error):
            return "Creating capture input for camera: \(error.localizedDescription)"
        case .deniedAuthorization:
            return "Camera access denied"
        case .restrictedAuthorization:
            return "Attempting to access a restricted capture device"
        case .unknownAuthorization:
            return "Unknown authorization status for capture device"
        }
    }
}
