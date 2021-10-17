import SwiftUI

struct PublicIpInfoView: View {
    let props: Props

    var body: some View {
        Text("ip: \(props.info?.ip ?? "-.-.-.-")")
                .overlay(progress)
    }

    @ViewBuilder
    private var progress: some View {
        if props.info.isNil {
            Color.white
                    .overlay(ProgressView { Text("Loading...") })
        }
    }
}