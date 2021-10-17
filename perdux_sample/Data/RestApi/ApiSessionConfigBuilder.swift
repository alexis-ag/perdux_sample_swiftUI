import Foundation

class ApiSessionConfigBuilder {
    static func buildConfig(
            timeoutForResponse: Double,
            timeoutResourceInterval: Double
    ) -> URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeoutForResponse
        sessionConfig.timeoutIntervalForResource = timeoutResourceInterval
        return sessionConfig
    }
}