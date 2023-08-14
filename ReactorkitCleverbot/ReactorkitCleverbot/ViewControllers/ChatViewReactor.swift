//
//  ChatViewReactor.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import ReactorKit
import RxSwift
import RxCocoa

final class ChatViewReactor: Reactor {
    enum Action {
        case send(String)
    }
    
    enum Mutation {
        case addMessage(Message)
    }
    
    struct State {
        var sections: [ChatViewSection] = [ChatViewSection(items: [])]
        var cleverbotState: String? = nil
    }
    
    let initialState: State = State()
    private let cleverbotService: CleverBotService
    
    init(cleverbotService: CleverBotService) {
        self.cleverbotService = cleverbotService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .send(let text):
            let outgoingMessage = Observable.just(Message.outgoing(.init(text: text)))
            let incomingMessage = self.cleverbotService
                .getReply(text: text, cs: self.currentState.cleverbotState)
                .map{ incomingMessage in Message.incoming(incomingMessage) }
            return Observable.of(outgoingMessage, incomingMessage).merge()
                .map{ message in Mutation.addMessage(message) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .addMessage(let message):
            let reactor = MessageCellReactor(message: message)
            let sectionItem: ChatViewSectionItem
            switch message {
            case .incoming:
                sectionItem = .inComingMessage(reactor)
            case .outgoing:
                sectionItem = .outgoingMessage(reactor)
            }
            state.sections[0].items.append(sectionItem)
            return state
        }
    }
}

