import Foundation

extension PublicIpInfoView {
    struct Props {
        let info: PublicIpInfo?
        let error: NetworkErrorType?
        let obtainInfo: ()->()
    }
}