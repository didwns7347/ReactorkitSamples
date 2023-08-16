//
//  ChatViewController.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit
import SwiftyColor
import Then

import ReactorKit
import ReusableKit
import RxDataSources
import RxKeyboard
import RxSwift


final class ChatViewController: BaseViewController, View {
    typealias Reactor = ChatViewReactor
    
    fileprivate struct Metric {
        static let messageSectionInsetTop = 10.0
        static let messageSectionInsetBottom = 10.0
        static let messageSectionInsetLeftRight = 10.0
        static let messageSectionItemSpacing = 10.0
    }
    
    private enum Font {
        static let placeholderLabel = UIFont.boldSystemFont(ofSize: 18)
    }
    
    private enum Color {
        static let placeholderLabelText = UIColor.gray
    }
    
    fileprivate struct Reusable {
        static let incomingMessageCell = ReusableCell<IncomingMessageCell>()
        static let outgoingMessageCell = ReusableCell<OutgoingMessageCell>()
    }
    
    private lazy var dataSource = self.createDataSource()
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<ChatViewSection> {
        return .init { dataSource, collectionView, indexPath, sectionItem in
            switch sectionItem {
            case .inComingMessage(let reactor):
                let cell = collectionView.dequeue(Reusable.incomingMessageCell, for: indexPath)
                cell.reactor = reactor
                //                cell.configCell()
                return  cell
            case .outgoingMessage(let reactor):
                let cell = collectionView.dequeue(Reusable.outgoingMessageCell, for: indexPath)
                cell.reactor = reactor
                //                cell.configCell()
                return cell
            }
        }
    }
    
    fileprivate let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then{
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.keyboardDismissMode = .interactive
        $0.register(Reusable.incomingMessageCell)
        $0.register(Reusable.outgoingMessageCell)
    }
    
    fileprivate let messageInputBar = MessageInputBar()
    
    private let placeholderLabel: UILabel = UILabel().then { v in
        v.font = Font.placeholderLabel
        v.text = "say hi"
        v.textColor = Color.placeholderLabelText
        v.isUserInteractionEnabled = false
    }
    
    init(reactor: Reactor) {
        super.init()
        self.title = "Cleverbot "
        self.reactor = reactor
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.collectionView.contentInset.bottom = self.messageInputBar.intrinsicContentSize.height
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.placeholderLabel)
        self.view.addSubview(self.messageInputBar)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
        layout()
    }
    
    func layout() {
        self.collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        self.placeholderLabel.snp.makeConstraints { make in
            make.center.equalTo(self.collectionView)
        }
        self.messageInputBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    
    
    func bind(reactor: Reactor) {
        // Delegate
        self.collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        // Action
        self.messageInputBar.rx.sendButtonTap
            .map(Reactor.Action.send)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        // State
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        // UI
        let wasReachedBottom: Observable<Bool> = self.collectionView.rx.contentOffset
            .map{ [weak self] _ in
                self?.collectionView.isReachedBottom() ?? false
            }
        
        reactor.state.map { $0.sections }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .withLatestFrom(wasReachedBottom) { ($0 , $1) }
            .filter{ _, wasReachedBottom in wasReachedBottom == true }
            .subscribe(onNext: { [weak self] _ in
                self?.collectionView.scrollToBottom(animated: true)
            } )
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sections.first?.items.isEmpty != true }
            .bind(to: self.placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        // keyboard
        RxKeyboard.instance.visibleHeight
            .drive { [weak self] keyboardVisibleHeight in
                guard let `self` = self else { return }
                self.messageInputBar.snp.updateConstraints{
                    var offset: CGFloat = -keyboardVisibleHeight
                    if keyboardVisibleHeight > 0 {
                        offset += self.view.safeAreaInsets.bottom
                    }
                    $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(offset)
                }
                self.view.setNeedsLayout()
                UIView.animate(withDuration: 0) {
                    self.collectionView.contentInset.bottom = keyboardVisibleHeight + self.messageInputBar.height
                    self.collectionView.scrollIndicatorInsets.bottom = self.collectionView.bottom
                    self.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.willShowVisibleHeight
            .drive { [weak self] keyboardVisibleHeight in
                self?.collectionView.scrollToBottom(animated: true)
            }
            .disposed(by: disposeBag)
        
        
    }
 
    
    
    
    
}
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = collectionView.cellWidth(forSectionAt: indexPath.section)
        let reactor = self.dataSource[indexPath]
        switch reactor {
        case .inComingMessage(let reactor):
            return IncomingMessageCell.size(thatFitsWidth: cellWidth, reactor: reactor)
            
        case .outgoingMessage(let reactor):
            return OutgoingMessageCell.size(thatFitsWidth: cellWidth, reactor: reactor)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Metric.messageSectionInsetTop,
            left: Metric.messageSectionInsetLeftRight,
            bottom: Metric.messageSectionInsetBottom,
            right: Metric.messageSectionInsetLeftRight
        )
    }
}
