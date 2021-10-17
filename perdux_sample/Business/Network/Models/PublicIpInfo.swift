import Foundation

struct PublicIpInfo: Codable, Hashable {
    let ip: String
    let iso: String
    let country: String
    let city: String
}
