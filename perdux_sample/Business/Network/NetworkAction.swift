import Foundation

enum NetworkAction: PerduxAction {
    static let executionQueue = DispatchQueue(label: "ConnectivityAction", qos: .default)

    case updateConnectivityStatus(_ status: NetworkStatus)

    case obtainPublicIpInfoProgress
    case obtainPublicIpInfoSuccess(_ info: PublicIpInfo)
    case obtainPublicIpInfoFail(_ cause: NetworkErrorType)
}
