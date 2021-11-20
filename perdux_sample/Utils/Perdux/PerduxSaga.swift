import Foundation

protocol PerduxSaga {
    func apply(_ effect: PerduxEffect)
}

class PerduxRootSaga: ActionDispatcherSubscriber {
    var sagas: [PerduxSaga] = []

    init() {
        ActionDispatcher.subscribe(self)
    }

    func add(saga: PerduxSaga) {
        sagas.append(saga)
    }

    func notify(_ action: PerduxAction) {
        guard let effect = action as? PerduxEffect else {
            return
        }

        sagas
                .forEach { $0.apply(effect) }
    }
}