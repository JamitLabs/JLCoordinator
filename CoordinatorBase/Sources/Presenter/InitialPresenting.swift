// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol InitialPresenting: Presenter {
    /// The window which screenflows are presented
    var window: UIWindow { get }
}
