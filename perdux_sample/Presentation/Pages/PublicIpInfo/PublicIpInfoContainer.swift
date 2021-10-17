import SwiftUI

struct PublicIpInfoContainer: View {
    let props: Props

    @EnvironmentObject private var connectivityState: NetworkState

    var body: some View {
        PublicIpInfoView(props: .init(
                info: connectivityState.publicIpInfo
        ))
    }
}
