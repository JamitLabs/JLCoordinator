// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func didTriggerModalViewController(in viewController: ViewController)
    func didTriggerModalNavigationController(in viewController: ViewController)
    func didTriggerPushViewController(in viewController: ViewController)
    func didTriggerModalTabController(in viewController: ViewController)
    func didTriggerCloseButton(in viewController: ViewController)
    func didTriggerCloseRootButton(in viewController: ViewController)
}

final class ViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?
    private lazy var lazyTabBarItem: UITabBarItem = .init(title: "View", image: nil, selectedImage: nil)
    override var tabBarItem: UITabBarItem! {
        get { return lazyTabBarItem }
        set { lazyTabBarItem = newValue }
    }

    @IBOutlet private var modalViewControllerButton: UIButton!
    @IBOutlet private var modalNavigationControllerButton: UIButton!
    @IBOutlet private var pushViewControllerButton: UIButton!
    @IBOutlet private var modalTabControllerButton: UIButton!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var closeRootButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = RandomColor.choose()
    }

    @IBAction private func didTriggerModalViewControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalViewController(in: self)
    }

    @IBAction private func didTriggerModalNavigationControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalNavigationController(in: self)
    }

    @IBAction private func didTriggerPushViewControllerButton(_ sender: UIButton) {
        delegate?.didTriggerPushViewController(in: self)
    }

    @IBAction private func didTriggerModalTabControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalTabController(in: self)
    }

    @IBAction private func didTriggerCloseButton(_ sender: UIButton) {
        delegate?.didTriggerCloseButton(in: self)
    }

    @IBAction private func didTriggerCloseRootButton(_ sender: UIButton) {
        delegate?.didTriggerCloseRootButton(in: self)
    }
}
