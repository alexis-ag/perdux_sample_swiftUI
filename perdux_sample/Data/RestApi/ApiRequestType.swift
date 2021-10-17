enum ApiRequestType: String, CustomStringConvertible {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case head   = "HEAD"

    var description: String {
        switch self {
        case .get:
            return "GET    "
        case .post:
            return "POST   "
        case .put:
            return "PUT    "
        case .delete:
            return "DELETE "
        case .head:
            return "HEAD   "
        }
    }

}
