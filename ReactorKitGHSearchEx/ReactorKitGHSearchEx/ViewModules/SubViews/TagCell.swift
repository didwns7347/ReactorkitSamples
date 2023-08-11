//
//  TagCell.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/08.
//

import UIKit
import SnapKit
class TagCell: UICollectionViewCell {
    static let id = "TagCell"
    
    let tagLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .gray
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLabel)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint() {
        tagLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
}
