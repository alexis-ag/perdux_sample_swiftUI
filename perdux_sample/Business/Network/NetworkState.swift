import Foundation
import Combine

class NetworkState: ReduxState {
    var networkStatus: NetworkStatus? = nil
    var publicIpInfo: PublicIpInfo? = nil
    var error: NetworkErrorType? =  nil

    override func reduce(with action: ReduxAction) {
        guard let action = action as? NetworkAction else {
            return
        }

        networkReducer.reduce(self, action)
    }
}