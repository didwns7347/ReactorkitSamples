//
//  IncomingMessageCell.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit

final class IncomingMessageCell: BaseMessageCell {
    fileprivate struct Color {
        static let bubleViewBackground = UIColor(named: "OutCellBG")!
        static let messageLabelText = UIColor.black
    }
    
    @objc init(frame: CGRect) {
        let appearance = Appearance(
            bubbleViewBackgroundColor: Color.bubleViewBackground,
            bubbleViewAlignment: .left,
            messageLabelTextColor: Color.messageLabelText
        )
        super.init(frame: frame, appearance: appearance)
    }
    
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
