import UIKit

protocol ViewControllerDelegate: AnyObject {
    func didTriggerModalViewController(in viewController: ViewController)
    func didTriggerFullscreenModalViewController(in viewController: ViewController)
    func didTriggerModalNavigationController(in viewController: ViewController)
    func didTriggerFullscreenModalNavigationViewController(in viewController: ViewController)
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

    var coordinatorCount: Int = 0 {
        didSet {
            guard isViewLoaded else { return }

            coordinatorCountLabel.text = "\(coordinatorCount)"
        }
    }

    @IBOutlet private var modalViewControllerButton: UIButton!
    @IBOutlet private var modalNavigationControllerButton: UIButton!
    @IBOutlet private var pushViewControllerButton: UIButton!
    @IBOutlet private var modalTabControllerButton: UIButton!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var closeRootButton: UIButton!
    @IBOutlet private var coordinatorCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = RandomColor.choose()
        // NOTE: CoordinatorCountLabel is optional for running unit tests (loading view is not working as workaround)
        coordinatorCountLabel?.text = "\(coordinatorCount)"
    }

    @IBAction private func didTriggerModalViewControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalViewController(in: self)
    }

    @IBAction private func didTriggerFullscreenModalViewControllerButton(_ sender: Any) {
        delegate?.didTriggerFullscreenModalViewController(in: self)
    }

    @IBAction private func didTriggerModalNavigationControllerButton(_ sender: UIButton) {
        delegate?.didTriggerModalNavigationController(in: self)
    }

    @IBAction private func didTriggerFullscreenModalNavigationControllerButton(_ sender: Any) {
        delegate?.didTriggerFullscreenModalNavigationViewController(in: self)
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
