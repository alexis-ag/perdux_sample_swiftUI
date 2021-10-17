import Foundation

let networkReducer: Reducer<NetworkState, NetworkAction> = Reducer { state, action in
    defer {  state.notifySUI() }

    switch action {
    case .obtainPublicIpInfoProgress:
        state.networkStatus = nil
        state.error = nil

    case let .updateConnectivityStatus(status):
        state.networkStatus = status

    case .obtainPublicIpInfoSuccess(let info):
        state.publicIpInfo = info

    case let .obtainPublicIpInfoFail(cause):
        state.error = cause
    }
}