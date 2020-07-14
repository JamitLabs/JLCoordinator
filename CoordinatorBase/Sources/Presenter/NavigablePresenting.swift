// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol NavigablePresenting: Presenter {
    var navigationController: UINavigationController { get }
}
