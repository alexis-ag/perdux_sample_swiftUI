import Foundation

let networkReducer: Reducer<NetworkState, NetworkAction> = Reducer { state, action in
    defer {  state.notifySUI() }

    switch action {
    case let .updateConnectivityStatus(status):
        state.networkStatus = status

    case .obtainPublicIpInfoSuccess(let info):
        state.publicIpInfo = info

    case .obtainPublicIpInfoFail:
        //todo implement fail reaction
        break
    }
}
