//
//  BaseViewController.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder: NSCoder) {
        self.init()
    }
    
    var disposeBag = DisposeBag()
    
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
    }
    
    func setupConstraints() {
        //override point
    }
}
