//
//  TaskCell.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import UIKit
import ReactorKit
import RxSwift
import SnapKit
import ManualLayout

final class TaskCell: BaseTableViewCell, View {
  
    
    typealias Reactor = TaskCellReactor
    
    struct Constant {
        static let titleLabelNumberOfLines = 2
    }
    
    struct Metric {
        static let cellPadding = 15.0
    }
    
    struct Font {
        static let titleLabel = UIFont.systemFont(ofSize: 14)
    }
    
    struct Color {
        static let titleLabelText = UIColor.black
    }
    
    let titleLabel = UILabel().then {
        $0.font = Font.titleLabel
        $0.textColor = Color.titleLabelText
        $0.numberOfLines = Constant.titleLabelNumberOfLines
    }
    
    override func initalize() {
        self.contentView.addSubview(self.titleLabel)
    }
    
    func bind(reactor: TaskCellReactor) {
        self.titleLabel.text = reactor.currentState.title
        self.accessoryType = reactor.currentState.isDone ? .checkmark : .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.titleLabel.top = Metric.cellPadding
        self.titleLabel.left = Metric.cellPadding
        self.titleLabel.width = self.contentView.width - Metric.cellPadding * 2
        self.titleLabel.sizeToFit()
    }
    
    class func height(fits width: CGFloat, reactor: Reactor) -> CGFloat {
      let height =  reactor.currentState.title.height(
        fits: width - Metric.cellPadding * 2,
        font: Font.titleLabel,
        maximumNumberOfLines: Constant.titleLabelNumberOfLines
      )
      return height + Metric.cellPadding * 2
    }

    
    
}
