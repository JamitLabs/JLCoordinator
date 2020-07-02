//
//  ViewController.swift
//  CoordinatorBaseExample
//
//  Created by Jens on 12.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

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
    private let stackView: UIStackView = .init()
    private let modalViewControllerButton: UIButton = .init(type: .system)
    private let modalNavigationControllerButton: UIButton = .init(type: .system)
    private let pushViewControllerButton: UIButton = .init(type: .system)
    private let modalTabControllerButton: UIButton = .init(type: .system)
    private let modalTabNavigationControllerButton: UIButton = .init(type: .system)
    private let addTabButton: UIButton = .init(type: .system)
    private let addTabNavigationButton: UIButton = .init(type: .system)
    private let closeButton: UIButton = .init(type: .system)
    weak var delegate: ViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = RandomColor.choose()
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                .init(item: stackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0),
                .init(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0)
            ]
        )

        setupButton(modalViewControllerButton, withTitle: "Modal ViewController", andTarget: #selector(didTriggerModalViewControllerButton(_:)))
        setupButton(
            modalNavigationControllerButton,
            withTitle: "Modal NavigationController",
            andTarget: #selector(didTriggerModalNavigationControllerButton(_:))
        )
        setupButton(pushViewControllerButton, withTitle: "Push ViewController", andTarget: #selector(didTriggerPushViewControllerButton(_:)))
        setupButton(modalTabControllerButton, withTitle: "Modal TabController", andTarget: #selector(didTriggerModalTabControllerButton(_:)))
        setupButton(
            modalTabNavigationControllerButton,
            withTitle: "Modal TabNavigationController",
            andTarget: #selector(didTriggerModalTabNavigationControllerButton(_:))
        )
        setupButton(addTabButton, withTitle: "Add Tab", andTarget: #selector(didTriggerAddTabButton(_:)))
        setupButton(addTabNavigationButton, withTitle: "Add NavigationTab", andTarget: #selector(didTriggerAddNavigationTabButton(_:)))
        setupButton(closeButton, withTitle: "Close View", andTarget: #selector(didTriggerCloseButton(_:)))
    }

    private func setupButton(_ button: UIButton, withTitle title: String?, andTarget target: Selector) {
        stackView.addArrangedSubview(button)
        button.backgroundColor = .white
        button.setTitle(title, for: [])
        button.addTarget(self, action: target, for: .touchUpInside)
    }

    @objc
    private func didTriggerModalViewControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalViewController(in: self)
    }

    @objc
    private func didTriggerModalNavigationControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalNavigationController(in: self)
    }

    @objc
    private func didTriggerPushViewControllerButton(_ sender: UIButton) {
        delegate?.didTriggerPushViewController(in: self)
    }

    @objc
    private func didTriggerModalTabControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalTabController(in: self)
    }

    @objc
    private func didTriggerModalTabNavigationControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalTabNavigationController(in: self)
    }

    @objc
    private func didTriggerAddTabButton(_ sender: UIButton) {
        delegate?.didTriggerAddTab(in: self)
    }

    @objc
    private func didTriggerAddNavigationTabButton(_ sender: UIButton) {
        delegate?.didTriggerAddTabNavigation(in: self)
    }

    @objc
    private func didTriggerCloseButton(_ sender: UIButton) {
        delegate?.didTriggerCloseButton(in: self)
    }
}
