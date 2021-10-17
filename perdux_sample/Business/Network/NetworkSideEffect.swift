import Foundation
import Combine

enum NetworkSideEffect: Effect {
    case forceUpdateStatus
    case startWatchConnectivityChanges
    case stopWatchConnectivityChanges

    static var executionQueue: DispatchQueue {
        get { DispatchQueue(label: "NetworkSideEffect", qos: .default) }
    }

    func apply() {
        switch self {
        case .forceUpdateStatus:
            Self.forceUpdateStatus()
        case .startWatchConnectivityChanges:
            Self.startWatchConnectivityChanges()
        case .stopWatchConnectivityChanges:
            Self.stopWatchConnectivityChanges()
        }
    }

    private static func forceUpdateStatus() {
        guard let service = F.get(type: INetworkService.self) else {
            return
        }

        ActionDispatcher.emitAsyncMain(NetworkAction.updateConnectivityStatus(service.status))
    }

    private static var networkObserver: AnyCancellable?
    private static func startWatchConnectivityChanges() {
        guard let service = F.get(type: INetworkService.self) else {
            return
        }

        networkObserver = service.networkPub
                .debounce(for: 1, scheduler: executionQueue)
                .map { NetworkAction.updateConnectivityStatus($0) }
                .sink { action in ActionDispatcher.emitAsyncMain(action) }
    }

    private static func stopWatchConnectivityChanges() {
        networkObserver?.cancel()
    }
}
