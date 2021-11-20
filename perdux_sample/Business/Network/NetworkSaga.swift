import Foundation
import Combine

class NetworkSaga: PerduxSaga {
    private var pipelines: Set<AnyCancellable> = []
    private let networkService: INetworkService

    init(
            networkService: INetworkService
    ) {
        self.networkService = networkService
    }

    public func apply(_ effect: PerduxEffect) {
        guard let effect = effect as? NetworkSideEffect else {
            return
        }

        switch effect {
        case .forceUpdateStatus:
            forceUpdateStatus()
        case .startWatchConnectivityChanges:
            startWatchConnectivityChanges()
        case .stopWatchConnectivityChanges:
            stopWatchConnectivityChanges()
        case .obtainPublicIpInfo:
            obtainPublicIpInfo()
        }
    }

    private func forceUpdateStatus() {
        ActionDispatcher.emitAsyncMain(NetworkAction.updateConnectivityStatus(networkService.status))
    }

    private func startWatchConnectivityChanges() {
        networkService.networkPub
                .debounce(for: 1, scheduler: NetworkSideEffect.executionQueue)
                .map { NetworkAction.updateConnectivityStatus($0) }
                .sink {
                    action in ActionDispatcher.emitAsync(action)
                }
                .store(in: &pipelines)
    }

    private func stopWatchConnectivityChanges() {
        pipelines
                .forEach { $0.cancel() }
    }

    private func obtainPublicIpInfo() {
        ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoProgress)

        switch networkService.getPublicIpInfo() {
        case let .success(info):
            ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoSuccess(info))
        case let .failure(err):
            ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoFail(.publicInfoObtainFail))
        }
    }
}
