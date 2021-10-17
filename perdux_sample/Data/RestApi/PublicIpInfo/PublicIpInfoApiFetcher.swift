import Foundation

protocol IPublicIpInfoFetcher {
    func getIpInfo() -> Result<PublicIpInfoApiModel, ApiError>
}

class PublicIpInfoFetcher: IPublicIpInfoFetcher {
    private let apiFetcher: IApiFetcher
    private let decoder: JSONDecoder = .init()

    init(
            apiFetcher: IApiFetcher
    ) {
        self.apiFetcher = apiFetcher
    }

    func getIpInfo() -> Result<PublicIpInfoApiModel, ApiError>{
        let path = ApiUrls.PublicIp.readPublicIpInfo

        let result: Result<ApiResponse, ApiError> = apiFetcher.get(
                path: path,
                headers: [:],
                queryParams: [:])

        switch result {
        case .success(let response):
            guard let data = response.data else {
                return .failure(
                        ApiError(
                                sender: self,
                                url: ApiUrls.PublicIp.readPublicIpInfo,
                                message: "no data",
                                requestType: .get
                        )
                )
            }

            guard let info = try? decoder.decode(PublicIpInfoApiModel.self, from: data) else {
                return .failure(
                        ApiError(
                                sender: self,
                                url: ApiUrls.PublicIp.readPublicIpInfo,
                                message: "failed to parse",
                                requestType: .get
                        )
                )
            }
            return .success(info)
        case .failure(let error):
            return .failure(error)
        }
    }
}
