import Foundation
import Combine

class NetworkState: PerduxState {
    var networkStatus: NetworkStatus? = nil {
        willSet { handleWillChange(sender: self, name: "networkStatus", oldValue:  networkStatus, newValue: newValue) }
        didSet { handleDidChange(sender: self, name: "networkStatus", oldValue: oldValue, newValue: networkStatus) }
    }

    var publicIpInfo: PublicIpInfo? = nil  {
        willSet { handleWillChange(sender: self, name: "publicIpInfo", oldValue:  publicIpInfo, newValue: newValue) }
        didSet { handleDidChange(sender: self, name: "publicIpInfo", oldValue: oldValue, newValue: publicIpInfo) }
    }

    var error: NetworkErrorType? =  nil  {
        willSet { handleWillChange(sender: self, name: "error", oldValue:  error, newValue: newValue) }
        didSet { handleDidChange(sender: self, name: "error", oldValue: oldValue, newValue: error) }
    }

    override func reduce(with action: PerduxAction) {
        guard let action = action as? NetworkAction else {
            return
        }

        networkReducer.reduce(self, action)
    }
}