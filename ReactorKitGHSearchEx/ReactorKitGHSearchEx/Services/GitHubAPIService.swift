//
//  GitHubAPIService.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import Foundation
import RxSwift

protocol GitHubAPIServiceType {
    func fetchRepositories(keyword: String) -> Observable<[Repository]>
}

class GitHubAPIService : BaseService, GitHubAPIServiceType {
    func fetchRepositories(keyword: String) -> Observable<[Repository]> {
        return .just([])
    }
    
    
}
