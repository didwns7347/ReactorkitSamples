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
    
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "리포지토리 키워드 입력"
        return searchController
    }()
    
    init(reactor: SearchViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        // Do any additional setup after loading the view.
    }
    
    
    func bind(reactor: SearchViewReactor) {
        self.searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .map( Reactor.Action.keywordInput )
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

private extension SearchViewController {
    func attribute() {
//        let searchController = UISearchController(searchResultsController: nil)
//        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
//        searchController.searchBar.placeholder = "게임, 앱, 스토리 등"
//        self.navigationItem.searchController = searchController
//
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.delegate = self
        
        self.navigationItem.searchController = self.searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "검색"
    }
}

