import SwiftUI

struct ConnectivityInfoView: View {
    let props: Props

    var body: some View {
        content
            .overlay(progress)
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            if let status = props.status {
                switch status.connected {
                case true:
                    Text("connected").foregroundColor(.green)
                case false:
                    Text("disconnected").foregroundColor(.red)
                }

                switch status.expensive {
                case true:
                    Text("cellular").foregroundColor(.red)
                case false:
                    Text("wi-fi").foregroundColor(.green)
                }
            }

            Button(action: props.forceCheck) {
                Text("Force check status")
            }.padding()
        }
    }

    @ViewBuilder
    private var progress: some View {
        if props.status.isNil {
            Color.white
                .overlay(ProgressView { Text("Loading...") })
        }
    }
}