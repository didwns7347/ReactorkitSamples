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
        case updateRepos(String)
        case loadNextPage
    }
    
    enum Mutation {
        case submiitedKeyword(String)
        case setRepos([Repository], nextPage: Int?)
        case appendRepos([Repository], nextPage: Int?)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var repositoryResult: [Repository]
        var nextPage: Int?
        var keyword: String
        var isLoadingNextPage: Bool
    }
    
    let provicer: ServiceProviderType
    let initialState: State
    
    init(provicer: ServiceProviderType) {
        self.provicer = provicer
        self.initialState = State(repositoryResult: [], nextPage: nil, keyword: "", isLoadingNextPage: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateRepos(let keyword):
            return Observable.concat([
                
                Observable.just(Mutation.submiitedKeyword(keyword)),
                
                self.provicer
                    .gitHubAPIService.fetchRepositories(keyword: keyword, page: 1)
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map{Mutation.setRepos($0, nextPage: 2)}
            ])
            
        case .loadNextPage:
            if self.currentState.isLoadingNextPage {
                return .empty()
            }
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            return Observable.concat([
                
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                self.provicer.gitHubAPIService
                    .fetchRepositories(
                        keyword: currentState.keyword,
                        page: page
                    )
                    .take(until: self.action.filter(Action.isUpdateQueryAction))
                    .map{ Mutation.appendRepos($0, nextPage: page+1) },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRepos(let newRepositories, let nextPage):
            newState.nextPage = nextPage
            newState.repositoryResult = newRepositories
            for repo in newRepositories {
                print(repo.name)
            }
            return newState
            
        case .submiitedKeyword(let keyword):
            newState.keyword = keyword
            return newState
            
        case .appendRepos(let loadedRepositories, let nextPage):
            newState.repositoryResult = currentState.repositoryResult + loadedRepositories
            newState.nextPage = nextPage
            return newState
            
        case .setLoadingNextPage(let isLoading):
            newState.isLoadingNextPage = isLoading
            return newState
        }
        
    }
    
    
}
extension SearchViewReactor.Action {
    static func isUpdateQueryAction(_ action: SearchViewReactor.Action) -> Bool {
        if case .updateRepos = action {
            return true
        } else {
            return false
        }
    }
}
