//
//  BaseCollectionViewCell.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    var disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
}
