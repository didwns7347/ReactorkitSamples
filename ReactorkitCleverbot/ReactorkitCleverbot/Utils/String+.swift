//
//  String+.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit

extension String {
  func boundingRect(with size: CGSize, attributes: [NSAttributedString.Key: Any]?) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return snap(rect)
  }

  func size(thatFits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
    var size = self.boundingRect(with: size, attributes: [.font: font]).size
    if maximumNumberOfLines > 0 {
      size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
    }
    return snap(size)
  }

  func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
  }

  func height(thatFitsWidth width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.size(thatFits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
  }
}

/// Ceil to snap pixel
func snap(_ x: CGFloat) -> CGFloat {
  let scale = UIScreen.main.scale
  return ceil(x * scale) / scale
}

func snap(_ point: CGPoint) -> CGPoint {
  return CGPoint(x: snap(point.x), y: snap(point.y))
}

func snap(_ size: CGSize) -> CGSize {
  return CGSize(width: snap(size.width), height: snap(size.height))
}

func snap(_ rect: CGRect) -> CGRect {
  return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}
