//
//  MessageInputBar.swift
//  ReactorkitCleverbot
//
//  Created by yangjs on 2023/08/14.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import UITextView_Placeholder
import SnapKit
final class MessageInputBar: UIView {
    
    private enum Metric {
        static let barHeight = 48.0
        static let barPaddingTopBottom = 7.0
        static let barPaddingLeftRight = 10.0
        static let sendButtonLeft = 7.0
    }
    
    fileprivate let toolbar = UIToolbar()
    
    fileprivate let textView = UITextView().then { v in
        v.placeholder = "say something"
        v.font = .systemFont(ofSize: 15)
        v.isEditable = true
        v.showsVerticalScrollIndicator = false
        v.textContainerInset.left = 8
        v.textContainerInset.right = 8
        v.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.6).cgColor
        v.layer.borderWidth = 1/UIScreen.main.scale
        v.layer.cornerRadius = Metric.barHeight / 2 - Metric.barPaddingTopBottom
    }
    
    fileprivate let sendButton = UIButton(type: .system).then { v in
        v.titleLabel?.font = .boldSystemFont(ofSize: 15)
        v.setTitle("send", for: .normal)
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.toolbar)
        self.addSubview(self.textView)
        self.addSubview(self.sendButton)
        
        self.toolbar.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(44)
        }
        
        self.textView.snp.makeConstraints { make in
            make.top.equalTo(Metric.barPaddingTopBottom)
            make.bottom.equalTo(-Metric.barPaddingTopBottom)
            make.left.equalTo(Metric.barPaddingLeftRight)
            make.right.equalTo(self.sendButton.snp.left).offset(-Metric.sendButtonLeft)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.barPaddingLeftRight)
            make.bottom.equalTo(-Metric.barPaddingLeftRight)
            make.right.equalTo(-Metric.barPaddingLeftRight)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.width, height: Metric.barHeight)
    }
}

extension Reactive where Base: MessageInputBar {
    var sendButtonTap: ControlEvent<String> {
        let source: Observable<String> = self.base.sendButton.rx.tap
            .withLatestFrom(self.base.textView.rx.text.asObservable())
            .flatMap{ text -> Observable<String> in
                if let text = text, !text.isEmpty {
                    return .just(text)
                } else {
                    return .empty()
                }
            }
            .do(onNext:{ [weak base = self.base] _ in
                base?.textView.text = nil
            })
        
        return ControlEvent(events: source)
    }
}
