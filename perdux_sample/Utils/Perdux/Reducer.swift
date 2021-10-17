struct Reducer<State: PerduxState, Action: PerduxAction> {
    let reduce: (State, Action) -> Void
}