import Foundation
import Combine

enum NetworkSideEffect: PerduxEffect {
    case forceUpdateStatus
    case startWatchConnectivityChanges
    case stopWatchConnectivityChanges
    case obtainPublicIpInfo

    static var executionQueue = DispatchQueue(label: "NetworkSideEffect", qos: .default)
}