import Foundation
import TwitterKit

class TwitterRequest {
    internal let client: TWTRAPIClient
    internal let ownUserId: String?
    private let baseUrl = "https://api.twitter.com/1.1/"
    internal var clientError : NSError?

    init() {
        ownUserId = Twitter.sharedInstance().sessionStore.session()?.userID
        client = TWTRAPIClient.init(userID: ownUserId)
    }

    func getURLRequest(requestType: RequestType, params: [AnyHashable : Any]?) -> URLRequest {
        let url = baseUrl + path()
        return client.urlRequest(withMethod: requestType.rawValue , url: url, parameters: params, error: &clientError)
    }

    internal func path() -> String {
        return "継承したクラスでパスを入れる"
    }

    internal func convertJSON(data: Data) -> NSArray? {
        let json = try! JSONSerialization.jsonObject(with: data, options: [])
        if let jsonArray = json as? NSArray {
            return jsonArray
        }

        return nil
    }

    internal func convertTweets(jsonArray: NSArray) -> [TWTRTweet] {
        if let tweets = TWTRTweet.tweets(withJSONArray: jsonArray as? [Any]) as? [TWTRTweet] {
            return tweets
        }

        return []
    }

    enum RequestType: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }

    enum TwitterRequestError: Error {
        case APIError
        case ResponseBlankError
        case JSONParseError
    }
}
