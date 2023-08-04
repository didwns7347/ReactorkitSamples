//
//  ViewController.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import UIKit
import ReactorKit
import RxCocoa

class SearchViewController: BaseViewController ,View {

    
    
    init(reactor: SearchViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func bind(reactor: SearchViewReactor) {
        
    }


}

