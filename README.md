# JLCoordinator Framework
A basic coordinator pattern implementation with presenter approach. Coordinators are managing the screen flow of your app and coordinating the connection between the UI and your models.

## Installation
The framework is configured to work with `Swift Package Manager`. Just add it to your dependencies.

## Components

### Coordinator Class
The framework is clustered into to main components the **Coordinator** and the **Presenter**. The **Coordinator** is used to handle the screen flow and the event delegation of its corresponding `UIViewController`. For example if a button is tapped on a view controller the coordinator should be informed about this. The coordinator then is able to handle the event and can for example start another screen flow. For more details just take a look into our example project which is included.

### Presenter Protocol
The **Presenter** is handling the way how the `UIViewController` of a **Coordinator** is presented. In some cases we need the flexibility to present `UIViewController` in different ways, for example modally or in a navigation stack. This is now solved through the **Presenter** just start the Coordinator with the presenter implementation of your choice. All coordinators which use a presenter are getting informed about a dismissal or presentation of an `UINavigationController` through the **predefined functions** in the **Coordinator**.

Another advantage of the **Presenter** is the handling of common `UIKit` events such as dismiss through swipe back on an `UINavigationController` or the in iOS 13 introduced adaptive dismiss for modally presented screens. If such an event occurs the coordinators which are using the presenter are informed about the dismissal of the `UIViewController` no matter how it was dismissed. 

Predefined presenter implementations for the most use cases are ready to use (see list below). If you have another use case, for example embedding an `UIViewController`, you can implement the `Presenter` protocol.

**Predefined implementations**

<details>
<summary><b>InitialPresenter</b></summary>
<br>
Is used to present in a `UIWindow` (e.g. used in `AppDelegate` or `SceneDelegate`)
</details>

<details>
<summary><b>ModalPresenter</b></summary>
<br>
Presents the coordinators `UIViewController` modally on a *PresentingViewController*
</details>

<details>
<summary><b>ModalNavigationPresenter</b></summary>
<br>
Presents a new NavigationController stack modally on a *PresentingViewController*. The first `UIViewController` will be set as `rootViewController` all further `UIViewControllers` will be pushed onto the stack. 
</details>

<details>
<summary><b>NavigationPresenter</b></summary>
<br>
Is initialized with an `UINavigationController` the first presented `UIViewController` is set as `rootViewController` the following are pushed onto the stack.
</details>

<details>
<summary><b>TabPresenter</b></summary>
<br>
Is used for presenting `UIViewController` embedded in a `UITabBarController` which has to be passed to the `TabPresenter`.
</details>

<details>
<summary><b>TabNavigationPresenter</b></summary>
<br>
Is used for presenting `UINavigationController` embedded in a `UITabBarController` which has to be passed to the `TabNavigationPresenter `. The first `UIViewController` is set as `rootViewController` all further will be pushed onto the stack.
</details>

## Usage

### Basic
To start implementing an app using the coordinator framework you should start by subclassing `Coordinator` and overriding its `start()` function. In most cases you have to present the rootViewController of the Coordinator in this function.

```swift
import CoordinatorBase
import UIKit

final class MyCoordinator: Coordinator {
    private let someViewController: UIViewController = UIStoryboard(name: "ViewController", bundle: nil).instantiateViewController(identifier: "ViewController")
    
    override func start() {
        super.start()
        someViewController.delegate = self
        presenter.present(someViewController, animated: true)
    }
}
```

After that go to your `AppDelegate`/`SceneDelegate` and initialize your coordinator with the given `InitialPresenter`.

```swift
import CoordinatorBase
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var myCoordinator: MyCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window: UIWindow = .init(windowScene: windowScene)
        myCoordinator = .init(presenter: InitialPresenter(window: window))
        myCoordinator?.start()
    }
}

```
### Starting a child coordinator

Starting a child coordinator is really easy, just instantiate your child with a presenter of your choice, add the coordinator to the parent and call the `start()` function of the child.

```swift
func startNextCoordinator() {
    let child: MyChildCoordinator = .init(presenter: ModalPresenter(presentingViewController: viewController))
    add(childCoordinator: child)
    viewCoordinator.start()
}
```

### Stopping a coordinator

If you want to stop a coordinator you just have to call the `stop()` function. If you call `stop()` not only the one coordinator is stopped but it will stop all children and afterwards it informs the parent coordinator that it has been removed (`didRemove(child:)`) and stopped (`didStop(child:)`).

### Getting informed about completed dismissals and presententations

The **Coordinator** provides through implementing the `PresenterObserving` protocol several functions to get informed about the dismiss and present completion of `UIViewControllers` or `UINavigationController`. If you want to get informed about the dismissal of a `UIViewController` just override following functions:

```swift
// If an UIViewController is dismissed this function is called
override func presenter(_ presenter: Presenter, didDismiss viewController: UIViewController) {
	// Do some stuff what should happend if the viewController is dismissed
	// for example: stop()
}

// If an UINavigationController is dismissed this function is called
override func presenter(_ presenter: Presenter, didDismiss navigationController: UINavigationController) {
	// Do some stuff what should happend if the navigationController is dismissed
	// You could check if this was the NavigationController of a specific UIViewController
	guard myViewController.navigationController === navigationController else { return }
	
	stop()
}
```

If you want to get informed about the completed present process just override following function:

```swift
override func presenter(_ presenter: Presenter, didPresent viewController: UIViewController) {
    // Do some stuff
}
```

For further examples please take a look into the included example project.

## Development
These tools are required for development of the project. Please make sure to have installed the correct versions or install them for example via Homebrew 🍻

| Tool                          | Version        |
| ------------------------------|:-------------: |
| Xcode                         | 11.5           |
| Swift                         | 5.2            |
| SwiftLint                     | min 0.38.2     |

## SwiftLint
SwiftLint is used to enforce our code styles and conventions. The configuration file is placed in the root folder of the project.

## Contribution Guidelines
- [How to work in an iOS project at JamitLabs](https://www.notion.so/jamitlabs/WIP-Einstieg-in-die-iOS-Entwicklung-80f531c2a4ef4525bda873958e6c1849)
- [How to do Merge Requests](https://www.notion.so/jamitlabs/How-To-Manage-Merge-Request-FAQ-167bc39b324a4c829281426f8d935dcc)
- [Follow our best practices and conventions](https://www.notion.so/jamitlabs/Best-Practices-Know-How-c8f0ab2969ff40e6b6a97833466493a6)
- [General information](https://www.notion.so/jamitlabs/Apple-Devs-23e4ee8c9a984c84a187e1d3bdfdedbb)

## Notes 
<<<<<<< HEAD
⚠️ If a certificate requires revocation please contact some of the CI maintainers

⚠️ SwiftGen is only able to generate colors from asset catalogs since iOS 11 the project 
=======
⚠️ If a certificate requires revokation please contact some of the CI maintainers
>>>>>>> a7f26d3... Adjust readme according to review
