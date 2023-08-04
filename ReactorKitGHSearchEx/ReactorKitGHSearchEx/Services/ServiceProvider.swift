//
//  ServiceProvider.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//

import Foundation
protocol ServiceProviderType : AnyObject{
    var gitHubAPIServiceType: GitHubAPIServiceType { get  }
}
class ServiceProvider : ServiceProviderType {
    lazy var gitHubAPIServiceType: GitHubAPIServiceType = GitHubAPIService(provider: self)
}
