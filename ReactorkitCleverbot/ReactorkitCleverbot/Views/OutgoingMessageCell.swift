//
//  OutgoingMessageCell.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit

final class OutgoingMessageCell: BaseMessageCell {

  // MARK: Constants

  fileprivate struct Color {
    static let bubbleViewBackground = 0x1680FA.color
    static let messageLabelText = UIColor.white
  }


  // MARK: Initializing

  @objc init(frame: CGRect) {
    let appearance = Appearance(
      bubbleViewBackgroundColor: Color.bubbleViewBackground,
      bubbleViewAlignment: .right,
      messageLabelTextColor: Color.messageLabelText
    )
    super.init(frame: frame, appearance: appearance)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
