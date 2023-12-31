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
import SafariServices

class RepositoryCell : UITableViewCell {
    static let identifier = "RepositoryCellID"
    var controller : UIViewController? = nil
    var tagList: [String] = []
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
    
    lazy var tagCollectionView : UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
            
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
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(ownerIcon)
        self.contentView.addSubview(repoDescription)
        self.contentView.addSubview(tagCollectionView)
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
            $0.trailing.equalToSuperview().inset(50)
        }
        
        repoDescription.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)

        }
        
        tagCollectionView.snp.makeConstraints{
            $0.top.equalTo(repoDescription.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
}
extension RepositoryCell: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.id, for: indexPath) as? TagCell else {
            return UICollectionViewCell()
        }
        if tagList.count <= indexPath.row
        {
            return cell
        }
        cell.tagLabel.text = "#\(tagList[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if tagList.count == 0{
            return .zero
        }
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = "#\(tagList[indexPath.row])"
        label.sizeToFit()
    
        let size = label.frame.size
        
        return CGSize(width: size.width + 16, height: size.height + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let path = "https://github.com/topics/\(tagList[indexPath.row])"
        guard let url = URL(string: path), let controller = self.controller else { return }
        let vc = SFSafariViewController(url: url)
        controller.present(vc, animated: true)
    }
    
}
