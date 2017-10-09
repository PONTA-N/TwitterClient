import Foundation
import TwitterKit

class UserDetailViewController: UITableViewController {
    var user: TWTRUser?
    internal var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    let userTimelineRequest = UserTimelineRequest()

    static func instantiate(user: TWTRUser) -> UserDetailViewController {
        let viewController = UIStoryboard(name: "UserDetail", bundle: nil).instantiateInitialViewController() as! UserDetailViewController
        viewController.user = user
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBarTitle()
        registerHeaderView()
        getUserTweets(maxId: nil)
    }

    private func configureNavigationBarTitle() {
        guard let user = user else {
            return
        }
        navigationItem.title = user.name
    }

    private func showTweetGetErrorAlert() {
        let alertController = UIAlertController(title: "エラー",message: "Tweetの取得に失敗しました。通信状況を確認してください。", preferredStyle: UIAlertControllerStyle.alert)
        let confirmButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(confirmButton)
        present(alertController,animated: true,completion: nil)
    }

    private func configureTableView() {
        tableView.estimatedRowHeight = TweetCell.estimatedHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = UserDetailView.height
        tableView.register(UINib(nibName: TweetCell.nibName, bundle: nil), forCellReuseIdentifier: TweetCell.cellIdentifier)
    }

    private func registerHeaderView() {
        let headerNib = UINib(nibName: UserDetailView.nibName , bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: UserDetailView.identifier)

    }

    internal func getUserTweets(maxId: String?) {
        guard let user = user else {
            return
        }
        
        userTimelineRequest.getUserTimelineTweets(screenName: user.screenName, maxId: maxId, tweets: {[weak self] tweets in
            self?.tweets += tweets
        }) { [weak self] error in
            self?.showTweetGetErrorAlert()
        }
    }
}

// MARK: - UITableViewDataSource
extension UserDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweets.count {
            let maxId = tweets.last?.tweetID
            getUserTweets(maxId: maxId)
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let detailView =  tableView.dequeueReusableHeaderFooterView(withIdentifier: UserDetailView.identifier) as! UserDetailView
        detailView.user = user
        return detailView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
