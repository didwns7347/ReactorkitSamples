//
//  TaskCellReactor.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import ReactorKit
import RxCocoa
import RxSwift

class TaskCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: Task
    
    init(task: Task) {
        self.initialState = task
    }
}
