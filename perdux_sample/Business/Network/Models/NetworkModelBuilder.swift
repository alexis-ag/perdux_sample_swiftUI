//
// Created by Alexis Grigorev on 17.10.2021.
//

import Foundation

struct NetworkModelBuilder {
    static func buildPublicIpInfo(_ apiModel: PublicIpInfoApiModel) -> PublicIpInfo? {
        PublicIpInfo(
                ip: apiModel.query,
                iso: apiModel.countryCode,
                country: apiModel.country,
                city: apiModel.city
        )
    }
}