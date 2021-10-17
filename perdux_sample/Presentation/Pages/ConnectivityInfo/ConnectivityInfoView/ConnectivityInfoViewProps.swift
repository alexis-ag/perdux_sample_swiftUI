import Foundation

extension ConnectivityInfoView {
    struct Props {
        let status: NetworkStatus?
        let forceCheck: ()->()
    }
}