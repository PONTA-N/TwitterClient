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
        //TODO: タイムライン画面に遷移する処理を追加
    }
}
