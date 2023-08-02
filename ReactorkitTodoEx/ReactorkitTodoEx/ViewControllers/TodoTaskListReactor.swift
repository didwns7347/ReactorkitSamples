//
//  TodoTaskListReactor.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import ReactorKit
import RxDataSources
import RxCocoa
import RxSwift

typealias TaskListSection = SectionModel<Void, TaskCellReactor>

final class TaskListViewReactor: Reactor {
    
    enum Action {
        case refresh
        case toggleEditing
        case toggleTaskDone(IndexPath)
        case deleteTask(IndexPath)
        case moveTask(IndexPath, IndexPath)
    }
    
    enum Mutation {
        case toggleEditing
        case setSections([TaskListSection])
        case insertSectionItem(IndexPath, TaskListSection.Item)
        case updateSectionItem(IndexPath, TaskListSection.Item)
        case deleteSectionItem(IndexPath)
        case moveSectionItem(IndexPath, IndexPath)
    }
    
    struct State {
        var isEditing: Bool
        var sections: [TaskListSection]
    }
    
    let provider: ServiceProviderType
    let initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        self.initialState = State(
            isEditing: false,
            sections: [TaskListSection(model: Void(), items: [])]
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return self.provider.taskService.fetchTasks()
                .map{ tasks in
                    let sectionItems = tasks.map(TaskCellReactor.init)
                    let section = TaskListSection(model: Void(), items: sectionItems)
                    return .setSections([section])
                }
        case .toggleEditing:
            return .just(.toggleEditing)
            
        case .toggleTaskDone(let indexPath):
            let task = currentState.sections[indexPath].currentState
            if !task.isDone {
                return self.provider.taskService.markAsDone(taskID: task.id)
                    .flatMap { _ in Observable.empty() }
            } else {
                return self.provider.taskService.markAsUndone(taskID: task.id)
                    .flatMap{ _ in Observable.empty() }
            }
            
        case .moveTask(let fromIndexPath, let toIndexPath):
            let task = currentState.sections[fromIndexPath].currentState
            return self.provider.taskService.move(taskID: task.id, to: toIndexPath.item)
                .flatMap { _ in Observable.empty() }
            
        case .deleteTask(let indexPath) :
            let task = currentState.sections[indexPath].currentState
            return self.provider.taskService.delete(taskID: task.id)
                .flatMap{ _ in Observable.empty() }
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let taskEventMutation = self.provider.taskService.event
            .flatMap{ [weak self] taskEvent -> Observable<Mutation> in
                self?.mutate(taskEvent: taskEvent) ?? .empty()
            }
        return Observable.of(mutation, taskEventMutation).merge()
    }
    
    private func mutate(taskEvent: TaskEvent) -> Observable<Mutation> {
        let state = self.currentState
        switch taskEvent {
        case .create(let task):
            let indexPath = IndexPath(item: 0, section: 0)
            let reactor = TaskCellReactor(task: task)
            return .just(.insertSectionItem(indexPath, reactor))
            
        case .update(let task):
            guard let indexPath = self.indexPath(forTaskID: task.id, from: state)
            else { return .empty()}
            let reactor = TaskCellReactor(task: task)
            return .just(.updateSectionItem(indexPath, reactor))
            
        case .delete(id: let id):
            guard let indexPath = self.indexPath(forTaskID: id, from: state)
            else { return .empty() }
            return .just(.deleteSectionItem(indexPath))
            
        case .move(id: let id, to: let to):
            guard let fromIndexPath = self.indexPath(forTaskID: id, from: state)
            else { return .empty() }
            let destinationIndexPath = IndexPath(item: to, section: 0)
            return .just(.moveSectionItem(fromIndexPath, destinationIndexPath))
            
        case .markAsDone(id: let id):
            guard let indexPath = self.indexPath(forTaskID: id, from: state)
            else { return .empty() }
            var task = state.sections[indexPath].currentState
            task.isDone = true
            let reactor = TaskCellReactor(task: task)
            return .just(.updateSectionItem(indexPath, reactor))
            
        case .markAsUnDone(id: let id):
            guard let indexPath = self.indexPath(forTaskID: id, from: state) else { return .empty() }
            var task = state.sections[indexPath].currentState
            task.isDone = false
            let reactor = TaskCellReactor(task: task)
            return .just(.updateSectionItem(indexPath, reactor))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSections(let sections):
            state.sections = sections
            return state
            
        case .toggleEditing :
            state.isEditing = !state.isEditing
            return state
            
        case .insertSectionItem(let indexPath, let sectionItem):
            state.sections.insert(sectionItem, at: indexPath)
            return state
            
        case .updateSectionItem(let indexPath, let sectionItem):
            state.sections[indexPath] = sectionItem
            return state
            
        case .deleteSectionItem(let indexPath):
            state.sections.remove(at: indexPath)
            return state
            
        case .moveSectionItem(let fromPath, let toPath):
            let sectionItem = state.sections.remove(at: fromPath)
            state.sections.insert(sectionItem, at: toPath)
            return state
        }
        
    }
    
    
    private func indexPath(forTaskID taskId: String, from state: State) -> IndexPath? {
        let section = 0
        let item = state.sections[section].items.firstIndex { reactor in
            reactor.currentState.id == taskId
        }
        if let item = item {
            return IndexPath(item: item, section: section)
        } else {
            return nil
        }
    }
    
    func reactorForCreatingTask() -> TaskEditViewReactor {
        return TaskEditViewReactor(provider: self.provider, mode: .new)
    }
    
    func reactorForEditingTask(_ taskCellReactor: TaskCellReactor) -> TaskEditViewReactor {
        let task = taskCellReactor.currentState
        return TaskEditViewReactor(provider: self.provider, mode: .edit(task))
    }
}
