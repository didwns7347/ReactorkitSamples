//
//  ServiceProvider.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/01.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var storageService: StorageServiceType { get }
    var alertService: AlertServiceType { get }
    var taskService: TaskServiceType  { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var storageService: StorageServiceType = UserDefaultsService(provider: self)
    lazy var alertService: AlertServiceType = AlertService(provider: self)
    lazy var taskService: TaskServiceType = TaskService(provider: self)
}
