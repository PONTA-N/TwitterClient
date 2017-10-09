import Foundation
import TwitterKit
import SDWebImage

protocol TweetCellDelegate: class {
    func didTapUserIconImage(user: TWTRUser)
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var userIconImage: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var likedCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetsUserView: UIView!
    @IBOutlet weak var retweetsUserIconImage: UIImageView!
    @IBOutlet weak var retweetsUserNameLabel: UILabel!
    @IBOutlet weak var retweetsUserViewHeightConstraint: NSLayoutConstraint!

    static let estimatedHeight: CGFloat = 60
    static let cellIdentifier = "TweetCell"
    static let nibName = "TweetCell"
    var defaultRetweetsUserViewHeight: CGFloat?

    weak var delegate: TweetCellDelegate? = nil
    var tweet: TWTRTweet? {
        didSet{
            guard let tweet = tweet else {
                return
            }

            // リツイートされたもの場合はリツイート元のものを表示する
            if let retweetedTweet = tweet.retweeted {
                retweetsUserView.isHidden = false
                let imageURL = URL(string: tweet.author.profileImageMiniURL)
                retweetsUserIconImage.sd_setImage(with:  imageURL, completed: nil)
                retweetsUserNameLabel.text = tweet.author.name
                retweetsUserViewHeightConstraint.constant = defaultRetweetsUserViewHeight!
                updateLayout(tweet: retweetedTweet)
            } else {
                retweetsUserView.isHidden = true
                retweetsUserViewHeightConstraint.constant = 0
                updateLayout(tweet: tweet)
            }

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutUserIconImage()
        layoutRetweetsUserIconImage()
        configureTapUserIconImageGesture()
        defaultRetweetsUserViewHeight = retweetsUserView.frame.size.height
    }

    func updateLayout(tweet: TWTRTweet) {
        userNameLabel.text = tweet.author.name
        screenNameLabel.text = tweet.author.screenName
        bodyLabel.text = tweet.text
        createdLabel.text = tweet.createdAt.stringWithFormat(format: "MM/dd HH:mm")
        let imageURL = URL(string: tweet.author.profileImageURL)
        userIconImage.sd_setImage(with: imageURL, completed: nil)
        likedCountLabel.text = (String(tweet.likeCount) + "件のいいね！")
        retweetCountLabel.text = (String(tweet.retweetCount) + "件のリツイート")
        layoutIfNeeded()
    }


    func tappedUserIconImage(sender: UITapGestureRecognizer) {
        guard let tweet = tweet else {
            return
        }

        // リツイートされたもの場合はリツイート元のものに遷移するようにする
        if let retweetedTweet = tweet.retweeted {
            delegate?.didTapUserIconImage(user: retweetedTweet.author)
        } else {
            delegate?.didTapUserIconImage(user: tweet.author)
        }
    }

    private func layoutRetweetsUserIconImage() {
        retweetsUserIconImage.clipsToBounds = true
        retweetsUserIconImage.layer.borderColor = UIColor.lightGray.cgColor
        retweetsUserIconImage.layer.borderWidth = 0.2
        retweetsUserIconImage.layer.cornerRadius =  retweetsUserIconImage.frame.size.width * 0.5;
    }

    private func layoutUserIconImage() {
        userIconImage.clipsToBounds = true
        userIconImage.layer.borderColor = UIColor.lightGray.cgColor
        userIconImage.layer.borderWidth = 0.2
        userIconImage.layer.cornerRadius =  userIconImage.frame.size.width * 0.5;
    }

    private func configureTapUserIconImageGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TweetCell.tappedUserIconImage))
        tapGesture.numberOfTapsRequired = 1
        userIconImage.addGestureRecognizer(tapGesture)
    }
}
