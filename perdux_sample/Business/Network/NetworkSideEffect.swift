import Foundation
import Combine

enum NetworkSideEffect: Effect {
    case forceUpdateStatus
    case startWatchConnectivityChanges
    case stopWatchConnectivityChanges
    case obtainPublicIpInfo

    static var executionQueue: DispatchQueue {
        get { DispatchQueue(label: "NetworkSideEffect", qos: .default) }
    }

    private static var pipelines: Set<AnyCancellable> = []

    func apply() {
        switch self {
        case .forceUpdateStatus:
            Self.forceUpdateStatus()
        case .startWatchConnectivityChanges:
            Self.startWatchConnectivityChanges()
        case .stopWatchConnectivityChanges:
            Self.stopWatchConnectivityChanges()
        case .obtainPublicIpInfo:
            Self.obtainPublicIpInfo()
        }
    }

    private static func forceUpdateStatus() {
        guard let svc = F.get(type: INetworkService.self) else {
            return
        }

        ActionDispatcher.emitAsyncMain(NetworkAction.updateConnectivityStatus(svc.status))
    }

    private static func startWatchConnectivityChanges() {
        guard let svc = F.get(type: INetworkService.self) else {
            return
        }

        svc.networkPub
                .debounce(for: 1, scheduler: executionQueue)
                .map { NetworkAction.updateConnectivityStatus($0) }
                .sink { action in ActionDispatcher.emitAsync(action) }
                .store(in: &pipelines)
    }

    private static func stopWatchConnectivityChanges() {
        pipelines
                .forEach { $0.cancel() }
    }

    private static func obtainPublicIpInfo() {
        ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoProgress)

        guard let svc = F.get(type: INetworkService.self) else {
            ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoFail(.general))
            return
        }

        switch svc.getPublicIpInfo() {
        case let .success(info):
            ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoSuccess(info))
        case let .failure(err):
            ActionDispatcher.emitAsync(NetworkAction.obtainPublicIpInfoFail(.publicInfoObtainFail))
        }
    }
}
