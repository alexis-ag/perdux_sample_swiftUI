import Foundation

enum NetworkAction: ReduxAction {
    static let executionQueue = DispatchQueue(label: "ConnectivityAction", qos: .default)

    case updateConnectivityStatus(_ status: NetworkStatus)

    case obtainPublicIpInfoSuccess(_ info: PublicIpInfo)
    case obtainPublicIpInfoFail
}
