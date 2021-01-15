import JLCoordinator

public final class CoordinatorCounter {
    static let shared: CoordinatorCounter = .init()

    let observers: WeakCache<CoordinatorObserving> = .init()

    private init() { /* NOOP */ }

    public func register(_ observer: CoordinatorObserving) {
        guard !observers.contains(observer) else { return }

        observers.append(observer)
        notifyObserverAboutChangedObserverCount()
    }

    public func unregister(_ observer: CoordinatorObserving) {
        observers.remove(observer)
        notifyObserverAboutChangedObserverCount()
    }

    public func notifyObserverAboutChangedObserverCount() {
        observers.all.forEach {
            $0.coordinatorCounter(self, changedCountTo: observers.all.count)
        }
    }
}
