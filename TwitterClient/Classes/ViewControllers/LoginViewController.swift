import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: TWTRLogInButton!

    static func instantiate() -> LoginViewController {
        let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginButton()
    }

    private func configureLoginButton() {
        loginButton.logInCompletion = { [weak self] (session, error) in
            if session != nil {
                self?.showTopTabBarController()
            } else if error != nil {
                self?.showAuthErrorAlert()
            }
        }
    }

    private func showAuthErrorAlert() {
        let alertController = UIAlertController(title: "エラー",message: "認証に失敗しました。通信状況を確認してください。", preferredStyle: UIAlertControllerStyle.alert)
        let confirmButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(confirmButton)
        present(alertController,animated: true,completion: nil)
    }

    private func showTopTabBarController() {
        let viewController = TopTabBarController.instantiate()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }
}
