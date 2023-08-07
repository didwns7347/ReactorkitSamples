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
import SnapKit

class RepositoryCell : UITableViewCell {
    static let identifier = "RepositoryCellID"
    
    lazy var titleLabel : UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20, weight: .bold)
        return v
    }()
    
    lazy var ownerIcon : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    lazy var repoDescription: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 15)
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
        self.repoDescription.text = model.description ?? ""
    }
}


private extension RepositoryCell {
    func initCell() {
        attribute()
    }
    
    func attribute() {
        self.addSubview(titleLabel)
        self.addSubview(ownerIcon)
        self.addSubview(repoDescription)
        layout()
    }
    
    func layout() {
        ownerIcon.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(30)
            $0.width.height.equalTo(30)
        }
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(ownerIcon.snp.trailing).offset(10)
            $0.centerY.equalTo(ownerIcon.snp.centerY)
        }
        repoDescription.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
}
