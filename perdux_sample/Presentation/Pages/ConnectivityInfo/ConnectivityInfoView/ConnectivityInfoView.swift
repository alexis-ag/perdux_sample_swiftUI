import SwiftUI

struct ConnectivityInfoView: View {
    let props: Props

    var body: some View {
        Text("connected: \(props.status?.connected.description ?? "false")")
            .overlay(progress)
    }

    @ViewBuilder
    private var progress: some View {
        if props.status.isNil {
            Color.white
                .overlay(ProgressView { Text("Loading...") })
        }
    }
}