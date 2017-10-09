import Foundation
import TwitterKit
import SDWebImage

class UserDetailView: UITableViewHeaderFooterView {

    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    static let identifier: String = "UserDetailView"
    static let nibName: String = "UserDetailView"
    static let height: CGFloat = 148

    var user: TWTRUser? {
        didSet{
            guard let user = user else {
                return
            }

            screenNameLabel.text = user.screenName
            userNameLabel.text = user.name
            let imageURL = URL(string: user.profileImageURL)
            userIconImageView.sd_setImage(with: imageURL, completed: nil)
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutUserIconImage()
    }

    private func layoutUserIconImage() {
        userIconImageView.clipsToBounds = true
        userIconImageView.layer.borderColor = UIColor.lightGray.cgColor
        userIconImageView.layer.borderWidth = 0.2
        userIconImageView.layer.cornerRadius =  userIconImageView.frame.size.width * 0.5;
    }
}
