import UIKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configureTwitter()
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let coordinator = Coordinator.init(window: window)
        coordinator.openRootViewController()

        return true
    }

    func configureTwitter() {
        guard let url = Bundle.main.url(forResource:"Twitter", withExtension: "plist") else {
            return
        }

        do {
            let data = try Data(contentsOf:url)
            let dictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
            let consumer_key = dictionary["consumer_key"] as! String
            let consumer_secret = dictionary["consumer_secret"] as! String
            Twitter.sharedInstance().start(withConsumerKey:consumer_key, consumerSecret:consumer_secret)
        } catch {
            print(error)
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
}
