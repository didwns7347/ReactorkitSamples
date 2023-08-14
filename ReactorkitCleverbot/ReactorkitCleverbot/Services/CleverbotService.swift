//
//  CleverbotService.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import Alamofire
import RxSwift
protocol CleverbotServiceType {
    func getReply(text: String, cs: String?) -> Observable<IncomingMessage>
}


final class CleverBotService {
    func getReply(text: String, cs: String?) -> Observable<IncomingMessage> {
        let urlString = "https://www.cleverbot.com/getreply"
        let apikey = Configuration.apiKey
        var parameters: [String: Any] = [
            "key": apikey,
            "input": text,
        ]
        if let cs = cs {
            parameters["cs"] = cs
        }
        return Observable.create { observer in
            let request = AF.request(urlString, parameters: parameters)
                .responseData { response in
                    switch response.result {
                    case .success(let jsonData):
                        do {
                            let incomingMessage = try IncomingMessage(data: jsonData)
                            observer.onNext(incomingMessage)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}
struct Configuration {
  /// Cleverbot API key. You may issue the free API key on the cleverbot website.
  ///
  /// - seealso: https://www.cleverbot.com/api/
  static let apiKey = "asdb"
}
