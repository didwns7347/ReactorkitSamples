//
//  Message.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import Foundation
import Then

enum Message {
    case incoming(IncomingMessage)
    case outgoing(OutgoingMessage)
    
    var text: String {
        switch self {
        case .incoming(let message):
            return message.text
        case .outgoing(let message):
            return message.text
        }
    }
}

protocol ModelType: Decodable, Then {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
    
    init(data: Data) throws {
        self = try Self.decoder.decode(Self.self, from: data)
    }
}

struct IncomingMessage: ModelType {
    var cs: String
    var text: String
    
    enum CodingKeys: String, CodingKey {
        case cs
        case text = "output"
    }
}

struct OutgoingMessage: ModelType {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
