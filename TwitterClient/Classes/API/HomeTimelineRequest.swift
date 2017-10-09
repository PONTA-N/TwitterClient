import Foundation
import TwitterKit

class HomeTImelineRequest: TwitterRequest {
    override func path() -> String {
        return "statuses/home_timeline.json"
    }

    func getHomeTimelineTweets(maxId: String?, tweets: @escaping ([TWTRTweet]) -> Void, error:@escaping (Error) -> Void) {
        let params = maxId != nil ? ["max_id": maxId!] : nil

        let request = getURLRequest(requestType: .GET, params: params)
        client.sendTwitterRequest(request) { [weak self](response, data, e) in
            if e != nil {
                error(TwitterRequestError.APIError)
            }

            if data == nil {
                error(TwitterRequestError.ResponseBlankError)
            }

            if let jsonArray = self?.convertJSON(data: data!) {
                var results = self?.convertTweets(jsonArray: jsonArray)
                if maxId != nil {
                    // maxIDに指定したツイートも含まれて返ってきてしまう為先頭を削除する事でページングがうまくいくようにする
                    results!.removeFirst()
                }
                tweets(results!)
            } else {
                error(TwitterRequestError.JSONParseError)
            }
        }
    }
}
