import Foundation
import Network
import Combine

typealias NetworkStatus = (connected: Bool, expensive: Bool, wasChanged: Bool)

protocol INetworkService {
    var status: NetworkStatus { get }
    func getPublicIpInfo() -> Result<PublicIpInfo, AppError>
    var networkPub: AnyPublisher<NetworkStatus, Never> { get }
}

class NetworkService: INetworkService {
    private let monitor = NWPathMonitor()
    private let publicIpInfoFetcher: IPublicIpInfoFetcher

    private let queue = DispatchQueue(label: "NetworkMonitor", qos: .userInitiated)
    private(set) var status: NetworkStatus = (connected: false, expensive: false, wasChanged: false)
    private let networkSub = PassthroughSubject<NetworkStatus, Never>()
    var networkPub: AnyPublisher<NetworkStatus, Never> { networkSub.eraseToAnyPublisher() }

    init (
            publicIpInfoFetcher: IPublicIpInfoFetcher
    ) {
        self.publicIpInfoFetcher = publicIpInfoFetcher

        startWatchNetworkCondition()
    }

    func getPublicIpInfo() -> Result<PublicIpInfo, AppError>{
        guard status.connected else {
            return .failure(AppError(sender: self, message: "no connection"))
        }

        switch publicIpInfoFetcher.getIpInfo() {
        case let .success(info):
            return .success(NetworkModelBuilder.buildPublicIpInfo(info))
        case let .failure(err):
            return .failure(AppError(sender: self, message: #function, error: err))
        }
    }

    private func startWatchNetworkCondition() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let strongSelf = self else {
                return
            }
            Logger.log(sender: NetworkService.self, message: "status: \(path.status), isExpensive: \(path.isExpensive)")

            let prevStatus = strongSelf.status
            let nextStatus = strongSelf.buildStatus(path: path, prevStatus: prevStatus)

            strongSelf.status = nextStatus

            self?.networkSub.send(nextStatus)
        }

        monitor.start(queue: queue)
    }

    private func buildStatus(path: NWPath, prevStatus: NetworkStatus) -> NetworkStatus {
        let isExpensive = path.isExpensive
        let isConnected = path.status == .satisfied
        let wasChanged = prevStatus.connected != isConnected

        return (
                connected: isConnected,
                expensive: isExpensive,
                wasChanged: wasChanged
        )
    }
}
