import SwiftUI

struct RootContainer: View {
    @State private var bottomNavItem: BottomNavItem = .connectivity

    var body: some View {
        TabView(selection: $bottomNavItem) {
            connectivityInfo
                    .tabItem {
                        Image(systemName: "rectangle.connected.to.line.below")
                        Text("Connectivity")
                    }
                    .tag(BottomNavItem.connectivity)

            publicIpInfo
                    .tabItem {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                        Text("Public IP")
                    }
                    .tag(BottomNavItem.connectivity)
        }
    }

    private var connectivityInfo: some View {
        ConnectivityInfoContainer(props: .init())
    }

    private var publicIpInfo: some View {
        PublicIpInfoContainer(props: .init())
    }
}
