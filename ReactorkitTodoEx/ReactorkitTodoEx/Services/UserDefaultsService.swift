//
//  UserDefaultsService.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/01.
//

import Foundation

extension UserDefaultsKey {
    static var tasks: Key<[[String : Any]]> { return "tasks"}
}

protocol StorageServiceType {
    func value<T>(forkey key: UserDefaultsKey<T>) -> T?
    func set<T>(value: T?, forkey key: UserDefaultsKey<T>)
}

final class UserDefaultsService: BaseService, StorageServiceType {
    private var defults: UserDefaults {
        return UserDefaults.standard
    }
    
    func value<T>(forkey key: UserDefaultsKey<T>) -> T? {
        return self.defults.value(forKey:key.key) as? T
    }
    
    func set<T>(value: T?, forkey key: UserDefaultsKey<T>) {
        self.defults.set(value, forKey: key.key)
        self.defults.synchronize()
    }
}
