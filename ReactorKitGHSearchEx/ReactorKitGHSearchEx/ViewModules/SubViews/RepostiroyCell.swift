//
//  RepostiroyCell.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/07.
//

import UIKit
import ReactorKit
import RxCocoa
import Kingfisher

class RepositoryCell : UITableViewCell {
    static let identifier = "RepositoryCellID"
    
    lazy var titleLabel : UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20, weight: .bold)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var ownerIcon : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
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
        self.ownerIcon.kf.setImage(
            with: URL(string: model.owner.avatar_url),
            placeholder: UIImage(systemName: "person.circle.fill")
        )
    }
}


private extension RepositoryCell {
    func initCell() {
        attribute()
    }
    
    func attribute() {
        self.addSubview(titleLabel)
        self.addSubview(ownerIcon)
        layout()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            ownerIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: -30),
            ownerIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            ownerIcon.widthAnchor.constraint(equalToConstant: 40),
            ownerIcon.heightAnchor.constraint(equalToConstant: 40),
            ownerIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(equalTo: self.ownerIcon.trailingAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 30)
        ])
    }
    
}
