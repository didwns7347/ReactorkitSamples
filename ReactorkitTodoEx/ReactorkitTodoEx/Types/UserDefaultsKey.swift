//
//  UserDefaultsKey.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/01.
//

import Foundation

struct UserDefaultsKey<T> {
    typealias Key<T> = UserDefaultsKey<T>
    let key: String
}

extension UserDefaultsKey: ExpressibleByStringLiteral {
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(key: value)
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(key: value)
    }
}

/*
 ExpressibleByStringLiteral을 프로토콜을 체택하면 문자열을 이용해 초기ㅎ가 가능함.
 struct MyString: ExpressibleByStringLiteral {
     var value: String

     init(stringLiteral value: String) {
         self.value = value
     }
 }
 let myString: MyString = "Hello, Swift!"
 print(myString.value) // 출력: "Hello, Swift!"
 */
