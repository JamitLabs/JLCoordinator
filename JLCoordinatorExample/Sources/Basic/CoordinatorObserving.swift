import JLCoordinator

public protocol CoordinatorObserving: AnyObject {
    func coordinatorCounter(_ counter: CoordinatorCounter, changedCountTo count: Int)
}

public extension CoordinatorObserving {
    func coordinatorCounter(_ counter: CoordinatorCounter, changedCountTo count: Int) { /* NOOP */ }
}
