import UIKit

public protocol InitialPresenting: Presenter {
    /// The window which screenflows are presented
    var window: UIWindow { get }
}
