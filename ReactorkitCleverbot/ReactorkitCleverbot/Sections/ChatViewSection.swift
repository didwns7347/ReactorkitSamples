//
//  ChatViewSection.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import RxDataSources

struct ChatViewSection {
    var items: [ChatViewSectionItem]
    
    init(items: [ChatViewSectionItem]) {
        self.items = items
    }
    
}

extension ChatViewSection: SectionModelType {
    init(original: ChatViewSection, items: [ChatViewSectionItem]) {
      self = original
      self.items = items
    }
}
enum ChatViewSectionItem {
    case inComingMessage(MessageCellReactor)
    case outgoingMessage(MessageCellReactor)
}
