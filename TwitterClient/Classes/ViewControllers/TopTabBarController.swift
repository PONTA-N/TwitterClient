import Foundation
import UIKit
import TwitterKit
class TopTabBarController: UITabBarController {
    let indicator = UIActivityIndicatorView()

    @IBOutlet weak var logoutButton: UIBarButtonItem!

    class func instantiate() -> TopTabBarController {
        return UIStoryboard(name: "TopTabBar", bundle: nil).instantiateInitialViewController() as! TopTabBarController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        loadMyUserData()
        clearBackButtonText()
    }

    private func loadMyUserData() {
        showIndicator()
        UserRequest().getOwnUserData(user: {[weak self] user in
            self?.indicator.stopAnimating()
            self?.configureMyUserDeta(user: user)

        }) {[weak self] error in
            self?.indicator.stopAnimating()
        }

    }

    private func configureMyUserDeta(user: TWTRUser) {
        for viewController in viewControllers! {
            if let detailViewController = viewController as? UserDetailViewController {
                detailViewController.user = user
            }
        }
    }

    private func showIndicator() {
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        view.bringSubview(toFront: indicator)
        indicator.startAnimating()
    }

    private func clearBackButtonText() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }

    private func doLogout() {
        let sessionStore = Twitter.sharedInstance().sessionStore
        guard let userID = sessionStore.session()?.userID else{
            transitionLoginViewController()
            return
        }

        sessionStore.logOutUserID(userID)
        transitionLoginViewController()
    }

    private func transitionLoginViewController() {
        guard let appDelegate = UIApplication.shared.delegate,
        let window = appDelegate.window else {
            return
        }

        self.dismiss(animated: true, completion: nil)
        let loginViewController = LoginViewController.instantiate()
        window?.rootViewController = loginViewController
    }

    @IBAction func didTapLogOutButton() {
        doLogout()
    }
}

// MARK: - UITabBarControllerDelegate
extension TopTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        switch viewController {
        case is HomeTimelineViewController:
            navigationItem.title = "タイムライン"
            logoutButton.isEnabled = false
        case is UserDetailViewController:
            navigationItem.title = "マイプロフィール"
            logoutButton.isEnabled = true
        default:
            navigationItem.title = ""
        }

        return true
    }
}
