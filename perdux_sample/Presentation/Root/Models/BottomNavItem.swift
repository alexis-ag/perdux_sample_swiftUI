import Foundation

enum BottomNavItem: String, Identifiable {
    var id: String   { self.rawValue }

    case connectivity = "connectivity"
    case publicIpInfo = "publicIpInfo"
}