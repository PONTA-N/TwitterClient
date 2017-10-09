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
    static let estimatedHeight: CGFloat = 60
    static let cellIdentifier = "TweetCell"
    static let nibName = "TweetCell"

    weak var delegate: TweetCellDelegate? = nil
    var tweet: TWTRTweet? {
        didSet{
            guard let tweet = tweet else {
                return
            }

            userNameLabel.text = tweet.author.name
            screenNameLabel.text = tweet.author.screenName
            bodyLabel.text = tweet.text
            createdLabel.text = tweet.createdAt.stringWithFormat(format: "MM/dd HH:mm")
            let imageURL = URL(string: tweet.author.profileImageURL)
            userIconImage.sd_setImage(with: imageURL, completed: nil)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutUserIconImage()
        configureTapUserIconImageGesture()
    }


    func tappedUserIconImage(sender: UITapGestureRecognizer) {
        guard let tweet = tweet else {
            return
        }

        delegate?.didTapUserIconImage(user: tweet.author)
        
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
