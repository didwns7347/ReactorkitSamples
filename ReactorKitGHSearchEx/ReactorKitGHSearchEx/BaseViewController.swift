//
//  BaseViewController.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
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

    }
    
 
}
