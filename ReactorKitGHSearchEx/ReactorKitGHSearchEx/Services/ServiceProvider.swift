//
//  ServiceProvider.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import Foundation
protocol ServiceProviderType : AnyObject{
    var gitHubAPIService: GitHubAPIServiceType { get  }
}
class ServiceProvider : ServiceProviderType {
    lazy var gitHubAPIService: GitHubAPIServiceType = GitHubAPIService(provider: self)
}
