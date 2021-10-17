import Foundation

extension CharacterSet {
    /// WARNING: '+' character used for sign space char ' ' in url (historically) but we use '+' as a part of phone number
    static let rfc3986Unreserved = CharacterSet(charactersIn: "?&=/:$-_.!*'(),ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
}