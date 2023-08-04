//
//  GitHubAPIService.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import Foundation
import RxSwift

protocol GitHubAPIServiceType {
    func fetchRepositories( keyword: String, page: Int  ) -> Observable<[Repository]>
}

class GitHubAPIService : BaseService, GitHubAPIServiceType {
    func fetchRepositories(keyword: String, page:Int = 1) -> Observable<[Repository]> {
        let urlString = "https://api.github.com/search/repositories?q=\(keyword)&page=\(page)&sort=stars"
        guard let reqeustURL = URL(string: urlString) else {
            return .just([])
        }
        let request = URLRequest(url: reqeustURL, timeoutInterval: 10)
        
        let tmp =  URLSession.shared.rx.data(request: request)
        //            .map { data in
        //
        //            }
        return .just([])
        
    }
    
}
