// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import JLCoordinator

public protocol CoordinatorObserving: AnyObject {
    func coordinatorCounter(_ counter: CoordinatorCounter, changedCountTo count: Int)
}

public extension CoordinatorObserving {
    func coordinatorCounter(_ counter: CoordinatorCounter, changedCountTo count: Int) { /* NOOP */ }
}
