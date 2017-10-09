import Foundation
import TwitterKit

class HomeTimelineViewController: UITableViewController {
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    let homeTimelineRequest = HomeTImelineRequest()

    static func instantiate() -> HomeTimelineViewController {
        let viewController = UIStoryboard(name: "HomeTimeline", bundle: nil).instantiateInitialViewController() as! HomeTimelineViewController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getTweets(maxId: nil)
        clearBackButtonText()
    }

    private func configureTableView() {
        tableView.estimatedRowHeight = TweetCell.estimatedHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: TweetCell.nibName, bundle: nil), forCellReuseIdentifier: TweetCell.cellIdentifier)
    }

    private func clearBackButtonText() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }

    internal func getTweets(maxId: String?) {
        homeTimelineRequest.getHomeTimelineTweets(maxId: maxId, tweets: {[weak self] tweets in
            self?.tweets += tweets
        }) { [weak self] error in
            self?.showTweetGetErrorAlert()
        }
    }

    private func showTweetGetErrorAlert() {
        let alertController = UIAlertController(title: "エラー",message: "Tweetの取得に失敗しました。通信状況を確認してください。", preferredStyle: UIAlertControllerStyle.alert)
        let confirmButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(confirmButton)
        present(alertController,animated: true,completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension HomeTimelineViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetCell.cellIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweets.count {
            let maxId = tweets.last?.tweetID
            getTweets(maxId: maxId)
        }
    }
}

// MARK: - TweetCellDelegate
extension HomeTimelineViewController: TweetCellDelegate {
    func didTapUserIconImage(user: TWTRUser) {
        let viewController = UserDetailViewController.instantiate(user: user)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
