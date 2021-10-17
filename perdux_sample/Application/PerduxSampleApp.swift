import SwiftUI

@main
struct PerduxSampleApp: App {
    public static var appStore: AppStore!

    init() {
        Self.configureIoC()
        Self.configureAppStore()
        Self.setupAppContext()
    }

    var body: some Scene {
        WindowGroup {
            ContentContainer(appStore: Self.appStore)
        }
    }

    static private func configureIoC() {
        ObjectFactory.initialize(with: DIContainerBuilder.build())
    }

    static private func configureAppStore() {
        appStore = .init()
        appStore.connect(state: NetworkState())
    }

    static private func setupAppContext() {
        ActionDispatcher.emitAsync(
                NetworkSideEffect.startWatchConnectivityChanges
        )
    }
}
