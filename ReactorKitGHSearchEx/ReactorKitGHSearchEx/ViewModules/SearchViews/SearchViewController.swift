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
import SafariServices

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
        tv.rowHeight = 100
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
            .map( Reactor.Action.updateRepos )
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map{ $0.repositoryResult }
            .bind(to: tableView.rx.items(cellIdentifier: RepositoryCell.identifier, cellType: RepositoryCell.self)){
                indexPath, repo, cell in
                cell.config(model: repo)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .filter { [weak self] offset in
                guard let `self` = self else { return false}
                guard self.tableView.frame.height > 0 else { return false}
                return offset.y + self.tableView.frame.height >= self.tableView.contentSize.height - 300
            }
            .map{ _ in Reactor.Action.loadNextPage}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext:{[weak self, weak reactor] indexPath in
                guard let `self` = self else { return }
                self.view.endEditing(true)
                self.tableView.deselectRow(at: indexPath, animated: true)
                guard let repo = reactor?.currentState.repositoryResult[indexPath.row] else { return }
                guard let url = URL(string: repo.htmlUrl) else { return }
                let vc = SFSafariViewController(url: url)
                self.searchController.present(vc, animated: true)
            })
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

