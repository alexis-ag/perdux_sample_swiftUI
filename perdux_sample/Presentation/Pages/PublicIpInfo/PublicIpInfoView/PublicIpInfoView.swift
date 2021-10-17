import SwiftUI

struct PublicIpInfoView: View {
    let props: Props

    var body: some View {
        content
                .overlay(progress)
    }

    @ViewBuilder
    private var progress: some View {
        if props.info.isNil,
           props.error.isNil {
            Color.white
                    .overlay(ProgressView { Text("Loading...") })
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            if let err = props.error {
                error(err)
            } else if let info = props.info {
                ipInfo(info)
            }

            Button(action: props.obtainInfo) {
                Text("Check Info")
            }.padding()
        }

    }

    @ViewBuilder
    private func error(_ err: NetworkErrorType) -> some View {
        switch err {
        case .general:
            Text("Some error with network")
        case .publicInfoObtainFail:
            Text("Failed to obtain public IP info")
        }
    }

    @ViewBuilder
    private func ipInfo(_ info: PublicIpInfo) -> some View{
        VStack {
            Text("IP: \(info.ip)")
        }
    }
}