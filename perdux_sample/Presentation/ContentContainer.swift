import SwiftUI

struct ContentContainer: View {
    let appStore: PerduxStore

    var body: some View {
        RootContainer()
            .environmentObject(appStore.getState(NetworkState.self))
    }
}