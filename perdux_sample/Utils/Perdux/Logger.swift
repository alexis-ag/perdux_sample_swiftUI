import Foundation
import os.log

func log(sender: Any, message: String) {
    Logger.log(sender: sender, message: message)
}

func log(sender: String, message: String) {
    Logger.log(sender: sender, message: message)
}

func log(sender: String = #fileID, functionName: String = #function, _ message: String, _ category: os.Logger = .reduxMsg) {
    let stroppedFileId = sender
            .replacingOccurrences(of: ".swift", with: "")
            .replacingOccurrences(of: "Kaller/", with: "")
    let strippedFunctionName = functionName
            .replacingOccurrences(of: ".swift", with: "")
            .replacingOccurrences(of: "Kaller/", with: "")
    Logger.log(sender: "\(stroppedFileId) \(strippedFunctionName)", message: message, category: category)
}

func log(sender: String = #fileID, _ error: Error, comment: String = "", _ category: os.Logger = .reduxMsg) {
    let strppedFileId = sender
            .replacingOccurrences(of: ".swift", with: "")
            .replacingOccurrences(of: "Kaller/", with: "")
    Logger.log(sender: strppedFileId, error: error, category: category)
}

func log<Action: PerduxAction>(_ action: Action, _ category: os.Logger = .reduxMsg) {
    Logger.log(action, category)
}

extension os.Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    // global loosely structured categories
    static let reduxAction = os.Logger(subsystem: subsystem, category: "🔄 Perdux Action")
    static let reduxEffect = os.Logger(subsystem: subsystem, category: "🔀 Perdux Effect")
    static let reduxState = os.Logger(subsystem: subsystem, category: "💿 Perdux State")
    static let reduxMsg = os.Logger(subsystem: subsystem, category: "ℹ️ Msg")
    static let error = os.Logger(subsystem: subsystem, category: "❗️Error")

    // logical categories
    static let ui = os.Logger(subsystem: subsystem, category: "⏯ UI")
    static let api = os.Logger(subsystem: subsystem, category: "↕️ API")
    static let socket = os.Logger(subsystem: subsystem, category: "🌐 Socket")
}

class Logger {

    class func log(error: NSException, data: [String: Any] = [:]) {
        #if DEBUG

        let msg =  """
                   Error: \(type(of: error)) at \(currentTime): name: \(error.name) 
                       reason: \(error.reason ?? "nil")
                       data: \(data)
                       callstack: \n\(error.callStackSymbols.joined(separator: "\n"))
                   """

        print(msg)
        #endif
    }

    class func log(error: Error) {
        #if DEBUG

        let msg = "Error: \(type(of: error)) at \(currentTime): \(error.localizedDescription)"
        print(msg)

        #endif
    }

    class func log(sender: String, error: Error, category logger: os.Logger) {
        #if DEBUG

        let msg = "Error: \(type(of: error)) \(error.localizedDescription)"
        logger.error("\(sender, align: .left(columns: 30), privacy: .public) \(msg, align: .left(columns: 30), privacy: .public)")

        #endif
    }

    class func log(state: PerduxState, fieldName: String, event: PerduxState.ChangesType, oldValue: Any?, newValue: Any?) {
        #if DEBUG

        let sender = "\(Mirror(reflecting: state).subjectType)"
        let oldValue = "\(oldValue ?? "nil")".prefix(256)
        let newValue = "\(newValue ?? "nil")".prefix(256)
        let msg =
                """
                '\(fieldName)' \(event)
                  from: \(oldValue)
                  to: \(newValue)
                """

        os.Logger.reduxState.info("\(sender, align: .left(columns: 30)) \(msg, align: .left(columns: 30))")
        #endif
    }

    class func log(sender: Any, message: String) {
        #if DEBUG

        let sender = "\(Mirror(reflecting: sender).subjectType)"
        os.Logger.reduxMsg.info("\(sender, align: .left(columns: 30)) \(message, align: .left(columns: 30))")

        #endif
    }

    class func log(sender: String, message: String) {
        #if DEBUG

        os.Logger.reduxMsg.info("\(sender, align: .left(columns: 30)) \(message, align: .left(columns: 30))")

        #endif
    }

    class func log(sender: String, message: String, category logger: os.Logger) {
        #if DEBUG

        logger.info("\(sender, align: .left(columns: 30), privacy: .public) \(message, align: .left(columns: 30), privacy: .public)")

        #endif
    }

    class func log(sender: Any, message: String, data: String) {
        #if DEBUG

        let sender = "\(Mirror(reflecting: sender).subjectType)"
        let msg = "\(message): \n\t \(data)"

        os.Logger.reduxMsg.info("\(sender, align: .left(columns: 30)) \(msg, align: .left(columns: 30))")

        #endif
    }

    class func log<Action: PerduxAction>(_ action: Action, _ category: os.Logger = .reduxAction) {
        #if DEBUG

        let sender = "\(type(of: action))"
        let msg = "\(action)".prefix(1024)

        category.info("\(sender, align: .left(columns: 30)) \(msg, align: .left(columns: 30))")

        #endif
    }

    class func log(_ effects: [PerduxEffect]) {
        effects
            .forEach(log)
    }

    class func log(_ effect: PerduxEffect) {
        #if DEBUG

        let sender = "\(type(of: effect))"
        let msg = "\(effect)"

        os.Logger.reduxEffect.info("\(sender, align: .left(columns: 30)) \(msg, align: .left(columns: 30))")

        #endif
    }

    private class var currentTime: String {
        Date().timeWithMillis
    }

    private class var currentFullDate: String {
        Date().toString(as: .rfc1123)
    }
}
