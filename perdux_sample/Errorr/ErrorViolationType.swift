import Foundation

enum ErrorViolation: String {
    case authProblem // some problems with authentication
    case silent // nothing special, we can ignore it and don't care
    case warning // something went wrong and we have to log it without any user reaction
    case error // something serious went wrong, we have to log it and notify user
    case fatal // something critical was happen, we have to log it and relaunch app
}