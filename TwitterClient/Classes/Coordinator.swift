import Foundation
import UIKit
import TwitterKit

class Coordinator {
    private var window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func openRootViewController() {
        if Twitter.sharedInstance().sessionStore.session()?.userID != nil {
            openHomeTimelineViewController()
        } else {
            openLoginViewController()
        }
    }

    func openLoginViewController() {
        let viewController = LoginViewController.instantiate()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

    func openHomeTimelineViewController() {
        let viewController = HomeTimelineViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
