// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

public protocol ModalPresenting: Presenter {
    var presentingViewController: UIViewController { get }
}
