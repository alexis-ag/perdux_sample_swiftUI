import Foundation

class AppStore: ActionDispatcherSubscriber {
    private(set) var states: [ReduxState] = []

    init() {
        ActionDispatcher.subscribe(self)
    }

    func connect(state: ReduxState) {
        states.append(state)
    }

    func notify(_ action: ReduxAction) {
        states
                .forEach { $0.reduce(with: action) }
    }

    func getState<T: ReduxState>(_ type: T.Type) -> T {
        let state = states.first { $0 is T }
        return state as! T
    }

    deinit {
        Logger.log(sender: self, message: "deInit")
    }
}
