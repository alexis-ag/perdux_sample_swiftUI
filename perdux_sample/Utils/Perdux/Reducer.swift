struct Reducer<State: ReduxState, Action: ReduxAction> {
    let reduce: (State, Action) -> Void
}