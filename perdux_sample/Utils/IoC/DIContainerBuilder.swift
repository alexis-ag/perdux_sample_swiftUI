// swiftlint:disable function_body_length
// swiftlint:disable line_length
import Foundation
import Swinject

class DIContainerBuilder {
    public static func build() -> Container {
        let container = Container()

        registerApiModules(container: container)
        registerNetworkModules(container: container)

        return container
    }

    private static func registerApiModules(container: Container) {
        container.register(IApiFetcher.self) { (resolver: Resolver) -> IApiFetcher in
            ApiFetcher()
        }
    }

    private static func registerNetworkModules(container: Container) {
        container.register(NetworkSaga.self) { (resolver: Resolver) -> NetworkSaga in
                    NetworkSaga(
                            networkService: resolver.resolve(INetworkService.self)!
                    )
                }
                .inObjectScope(.container)

        container.register(INetworkService.self) { (resolver: Resolver) -> INetworkService in
                    NetworkService(
                            publicIpInfoFetcher: resolver.resolve(IPublicIpInfoFetcher.self)!
                    )
                }
                .inObjectScope(.container)

        container.register(IPublicIpInfoFetcher.self) { (resolver: Resolver) -> IPublicIpInfoFetcher in
                    PublicIpInfoFetcher(
                            apiFetcher: ApiFetcher(
                                    sessionConfig: ApiSessionConfigBuilder.buildConfig(timeoutForResponse: 1, timeoutResourceInterval: 5)
                            )
                    )
                }
                .inObjectScope(.container)
    }
}
