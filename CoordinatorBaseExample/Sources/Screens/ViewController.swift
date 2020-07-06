// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func didTriggerModalViewController(in viewController: ViewController)
    func didTriggerModalNavigationController(in viewController: ViewController)
    func didTriggerPushViewController(in viewController: ViewController)
    func didTriggerModalTabController(in viewController: ViewController)
    func didTriggerModalTabNavigationController(in viewController: ViewController)
    func didTriggerAddTab(in viewController: ViewController)
    func didTriggerAddTabNavigation(in viewController: ViewController)
    func didTriggerCloseButton(in viewController: ViewController)
}

class ViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?

    @IBOutlet private var modalViewControllerButton: UIButton!
    @IBOutlet private var modalNavigationControllerButton: UIButton!
    @IBOutlet private var pushViewControllerButton: UIButton!
    @IBOutlet private var modalTabControllerButton: UIButton!
    @IBOutlet private var modalTabNavigationControllerButton: UIButton!
    @IBOutlet private var addTabButton: UIButton!
    @IBOutlet private var addTabNavigationButton: UIButton!
    @IBOutlet private var closeButton: UIButton!

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

    @IBAction private func didTriggerModalTabNavigationControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalTabNavigationController(in: self)
    }

    @IBAction private func didTriggerAddTabButton(_ sender: UIButton) {
        delegate?.didTriggerAddTab(in: self)
    }

    @IBAction private func didTriggerAddNavigationTabButton(_ sender: UIButton) {
        delegate?.didTriggerAddTabNavigation(in: self)
    }

    @IBAction private func didTriggerCloseButton(_ sender: UIButton) {
        delegate?.didTriggerCloseButton(in: self)
    }
}
