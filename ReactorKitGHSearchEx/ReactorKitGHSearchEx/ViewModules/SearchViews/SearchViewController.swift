//
//  ViewController.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources

class SearchViewController: BaseViewController ,View {
    
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "리포지토리 키워드 입력"
        return searchController
    }()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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
        
        reactor.state.map{ $0.repositoryResult }
            .bind(to: tableView.rx.items(cellIdentifier: RepositoryCell.identifier, cellType: RepositoryCell.self)){
                indexPath, repo, cell in
                cell.config(model: repo)
            }
            .disposed(by: disposeBag)
    }
}

private extension SearchViewController {
    func attribute() {
        
        self.navigationItem.searchController = self.searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "검색"
        self.view.addSubview(tableView)
        layout()
    }
    
    
    func layout() {
        NSLayoutConstraint.activate(
            [
                tableView
                    .topAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                tableView
                    .leadingAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                tableView
                    .trailingAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                tableView
                    .bottomAnchor
                    .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }
}

