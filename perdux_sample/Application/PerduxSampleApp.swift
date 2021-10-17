import SwiftUI

@main
struct PerduxSampleApp: App {
    public static var appStore: AppStore!

    init() {
        Self.configureAppStore()
    }

    var body: some Scene {
        WindowGroup {
            ContentContainer(appStore: Self.appStore)
        }
    }

    static private func configureAppStore() {
        appStore = .init()
        appStore.connect(state: NetworkState())
    }
}
