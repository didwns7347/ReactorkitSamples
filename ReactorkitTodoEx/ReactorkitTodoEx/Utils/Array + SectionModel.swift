//
//  Array + SectionModel.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/02.
//

import RxDataSources


extension Array where Element: SectionModelType {
    public subscript(indexPath: IndexPath) -> Element.Item {
        get {
            return self[indexPath.section].items[indexPath.row]
        }
        mutating set {
            self.update(section: indexPath.section) { items in
                items[indexPath.item] = newValue
            }
        }
    }
    
    public mutating func insert(
        _ newItem: Element.Item,
        at indexPath: IndexPath
    ) {
        self.update(section: indexPath.section) { items in
            items.insert(newItem, at: indexPath.item)
        }
    }
    
    @discardableResult
    public mutating func remove(
        at indexPath: IndexPath
    ) -> Element.Item {
        return self.update(section: indexPath.section) { items in
            items.remove(at: indexPath.row)
        }
    }
    
    private mutating func replace(section: Int, items: [Element.Item]) {
        self[section] = Element(original: self[section], items: items)
    }
    
    
    private mutating func update<T>(
        section: Int,
        mutate: (inout [Element.Item]) -> T
    ) -> T {
        var items = self[section].items
        var value = mutate(&items)
        self[section] = Element.init(original: self[section], items: items)
        return value
    }
}
