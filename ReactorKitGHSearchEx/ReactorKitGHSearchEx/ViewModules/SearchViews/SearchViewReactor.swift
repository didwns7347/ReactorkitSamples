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
        case keywordInput(String)
    }
    
    enum Mutation {
        case searchResult([Repository])
    }
    
    struct State {
        var repositoryResult: [Repository]
        var currentPage: Int
    }
    
    let provicer: ServiceProviderType
    let initialState: State
    
    init(provicer: ServiceProviderType) {
        self.provicer = provicer
        self.initialState = State(repositoryResult: [], currentPage: 1)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .keywordInput(let keyword):
            return self.provicer.gitHubAPIService.fetchRepositories(keyword: keyword, page: 1)
                .map(Mutation.searchResult)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .searchResult(let newRepositories):
            newState.currentPage = 1
            newState.repositoryResult = newRepositories
            return newState
        }
    }
    
}
