//
//  BaseTableViewCell.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    var disposeBag: DisposeBag = DisposeBag()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initalize()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initalize() {
        
    }
}
