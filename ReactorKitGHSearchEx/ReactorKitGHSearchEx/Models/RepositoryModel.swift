//
//  RepositoryModel.swift
//  ReactorKitGHSearchEx
//
//  Created by yangjs on 2023/08/04.
//


import Foundation
import RxDataSources
struct RepositoryList: Decodable {
    let items : [Repository]
    
    static func parse(data: Data)-> [Repository]{
        var list = [Repository]()
        do{
            let decoder = JSONDecoder()
            let repoList = try decoder.decode([Repository].self, from: data)
            list = repoList
            
        }catch{
            print(error)
        }
        return list
    }
}

struct Repository : Decodable, Equatable {
    
    let id : Int
    let name : String
    let description : String?
    let stargazersCount : Int
    let language : String?
    
    enum CodingKeys: String , CodingKey{
        case id,name,description,language
        case stargazersCount = "stargazers_count"
    }
    
}



