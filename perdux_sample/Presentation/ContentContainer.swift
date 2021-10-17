import SwiftUI

struct ContentContainer: View {
    let appStore: AppStore

    var body: some View {
        RootContainer()
            .environmentObject(appStore.getState(NetworkState.self))
    }
}