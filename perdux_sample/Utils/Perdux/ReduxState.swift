import Combine
import Foundation
import Combine

/*
 * ReduxState purpose is storing data in memory and notifying about it's change
 * Derived from ReduxStore classes contain their own fields with initial states
 * Fields initialised with NIL before they would be updated.
 * It means that their state is not determined yet
 * and on UI we show progress or nothing as initial UI state.
 */
open class ReduxState: ObservableObject {
    public let objectDidChange = ObservableObjectPublisher()
    private var observers: Set<AnyCancellable> = []
    private let updateSuiPub = ObservableObjectPublisher()

    init() {
        self.updateSuiPub
                .sink { _ in
                    exec { self.objectWillChange.send() }
                }
                .store(in: &observers)

    }

    public func reduce(with action: ReduxAction) {
        fatalError("\(#function) NOT IMPLEMENTED")
    }

    public func cleanup() throws {
        fatalError("\(#function) NOT IMPLEMENTED")
    }

    public func notifySUI() {
        updateSuiPub.send()
    }

    public func handleWillChange(sender: Any, name: String, oldValue: Any?, newValue: Any?) {
          DispatchQueue.global(qos: .utility).async {
              Logger.log(
                      state: self,
                      fieldName: name,
                      event: .willChange,
                      oldValue: oldValue,
                      newValue: newValue
              )
          }
    }

    public func handleDidChange(sender: Any, name: String, oldValue: Any?, newValue: Any?) {
        DispatchQueue.main.async {
            self.objectDidChange.send()
        }


        DispatchQueue.global(qos: .utility).async {
            Logger.log(
                    state: self,
                    fieldName: name,
                    event: .didChange,
                    oldValue: oldValue,
                    newValue: newValue)
        }
    }
}
