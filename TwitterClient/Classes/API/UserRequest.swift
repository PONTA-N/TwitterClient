import Foundation
import TwitterKit

class UserRequest: TwitterRequest {
    func getOwnUserData(user: @escaping(TWTRUser) -> Void, error:@escaping (Error) -> Void) {
        client.loadUser(withID: ownUserId!) { (result, e) in
            if e != nil {
                error(TwitterRequestError.APIError)
            }

            user(result!)
        }
    }
}
