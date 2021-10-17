import Foundation

class AppStore: ActionDispatcherSubscriber {
    private(set) var states: [PerduxState] = []

    init() {
        ActionDispatcher.subscribe(self)
    }

    func connect(state: PerduxState) {
        states.append(state)
    }

    func notify(_ action: PerduxAction) {
        states
                .forEach { $0.reduce(with: action) }
    }

    func getState<T: PerduxState>(_ type: T.Type) -> T {
        let state = states.first { $0 is T }
        return state as! T
    }

    deinit {
        Logger.log(sender: self, message: "deInit")
    }
}
