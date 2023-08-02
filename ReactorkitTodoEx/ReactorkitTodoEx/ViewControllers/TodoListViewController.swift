//
//  ViewController.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/07/31.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift
import ReusableKit
import RxViewController
import RxOptional

final class TodoListViewController: BaseViewController, View {
    struct Reusable {
        static let taskCell = ReusableCell<TaskCell>()
    }
    
    let dataSource = RxTableViewSectionedReloadDataSource<TaskListSection>(
      configureCell: { _, tableView, indexPath, reactor in
        let cell = tableView.dequeue(Reusable.taskCell, for: indexPath)
        cell.reactor = reactor
        return cell
    })
//    RxTableViewSectionedReloadDataSource<TaskListSection>(
//        configureCell: { _, tableView, indexPath, reactor in
//            let cell = tableView.dequeue(ReusableCell.taskCell, for: indexPath)
//            cell.reactor = reactor
//            return cell
//        }
//    )
    
    let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    let tableView = UITableView().then {
        $0.allowsSelectionDuringEditing = true
        $0.register(Reusable.taskCell)
    }
    
    init(reactor: TaskListViewReactor) {
        super.init()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = self.addButtonItem
        self.reactor = reactor
    }
    
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        self.tableView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func bind(reactor: TaskListViewReactor) {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.dataSource.canEditRowAtIndexPath = { _,_ in true }
        self.dataSource.canMoveRowAtIndexPath = { _,_ in true }
        
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.editButtonItem.rx.tap
            .map { Reactor.Action.toggleEditing }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .filterNot(reactor.state.map { $0.isEditing })
            .map { indexPath in .toggleTaskDone(indexPath) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.tableView.rx.itemDeleted
          .map(Reactor.Action.deleteTask)
          .bind(to: reactor.action)
          .disposed(by: self.disposeBag)

        self.tableView.rx.itemMoved
          .map(Reactor.Action.moveTask)
          .bind(to: reactor.action)
          .disposed(by: self.disposeBag)
        
        self.addButtonItem.rx.tap
          .map(reactor.reactorForCreatingTask)
          .subscribe(onNext: { [weak self] reactor in
            guard let `self` = self else { return }
            let viewController = TaskEditViewController(reactor: reactor)
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
          })
          .disposed(by: self.disposeBag)

        self.tableView.rx.modelSelected(TaskCellReactor.self)
          .filter(reactor.state.map { $0.isEditing })
          .map(reactor.reactorForEditingTask)
          .subscribe(onNext: { [weak self] reactor in
            guard let `self` = self else { return }
            let viewController = TaskEditViewController(reactor: reactor)
            let navigationController = UINavigationController(rootViewController: viewController)
            self.present(navigationController, animated: true, completion: nil)
          })
          .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map{ $0.sections }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.isEditing }
          .distinctUntilChanged()
          .subscribe(onNext: { [weak self] isEditing in
            guard let `self` = self else { return }
            self.navigationItem.leftBarButtonItem?.title = isEditing ? "Done" : "Edit"
            self.navigationItem.leftBarButtonItem?.style = isEditing ? .done : .plain
            self.tableView.setEditing(isEditing, animated: true)
          })
          .disposed(by: self.disposeBag)
    }

}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let reactor = self.dataSource[indexPath]
    return TaskCell.height(fits: tableView.width, reactor: reactor)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

}
