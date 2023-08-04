//
//  SearchViewReactor.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import Foundation
import ReactorKit
import RxSwift

class SearchViewReactor : Reactor {
   
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let provicer: ServiceProviderType
    let initialState: State
    
    init(provicer: ServiceProviderType) {
        self.provicer = provicer
        self.initialState = State()
    }
    
}
