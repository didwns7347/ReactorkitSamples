//
//  RepostiroyCell.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/07.
//

import UIKit
import ReactorKit
import RxCocoa

class RepositoryCell : UITableViewCell {
    static let identifier = "RepositoryCellID"
    
    lazy var titleLabel : UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20, weight: .bold)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(model:Repository) {
        self.titleLabel.text = model.name
    }
    

    
    
}
private extension RepositoryCell {
    func initCell() {
        attribute()
    }
    
    func attribute() {
        self.addSubview(titleLabel)
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 30)
        ])
    }
    
}
