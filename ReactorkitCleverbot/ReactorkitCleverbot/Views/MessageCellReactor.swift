//
//  MessageCellReactor.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import ReactorKit
import RxCocoa
import RxSwift

final class MessageCellReactor: Reactor {
    typealias Action = NoAction
    struct State {
        var message: String?
    }
    
    let initialState: State
    
    init(message: Message) {
        self.initialState = State(message: message.text)
    }
}
