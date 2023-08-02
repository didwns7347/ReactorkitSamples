//
//  TaskEditViewController.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import Foundation
import ReactorKit
import RxCocoa
import RxOptional
import SnapKit
class TaskEditViewController: BaseViewController,View {
    
    struct Metric {
      static let padding = 15.0
      static let titleInputCornerRadius = 5.0
      static let titleInputBorderWidth = 1 / UIScreen.main.scale
    }

    struct Font {
      static let titleLabel = UIFont.systemFont(ofSize: 14)
    }

    struct Color {
      static let titleInputBorder = UIColor.lightGray
    }


    // MARK: UI

    let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    let titleInput = UITextField().then {
      $0.autocorrectionType = .no
      $0.borderStyle = .roundedRect
      $0.font = Font.titleLabel
      $0.placeholder = "Do something..."
    }

    // MARK: Initializing

    init(reactor: TaskEditViewReactor) {
      super.init()
      self.navigationItem.leftBarButtonItem = self.cancelButtonItem
      self.navigationItem.rightBarButtonItem = self.doneButtonItem
      self.reactor = reactor
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: TaskEditViewReactor) {
        cancelButtonItem.rx.tap
            .map{ Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButtonItem.rx.tap
            .map{ Reactor.Action.submit }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.titleInput.rx.text
            .filterNil()
            .skip(1)
            .map(Reactor.Action.updateTaskTitle)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.title }
            .distinctUntilChanged()
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.taskTitle }
            .distinctUntilChanged()
            .bind(to: self.titleInput.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.canSubmit }
            .distinctUntilChanged()
            .bind(to: self.doneButtonItem.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map{ $0.isDismissed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
              self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.titleInput)
        setupConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.titleInput.becomeFirstResponder()
    }
    
    func setupConstraint() {
        self.titleInput.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top).offset(Metric.padding*5)
          make.left.equalTo(Metric.padding)
          make.right.equalTo(-Metric.padding)
        }
    }
    
}
