//
//  ModelType.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/01.
//

import Foundation
import Then
protocol ModelType: Then {
    
}

extension Collection where Self.Iterator.Element: Identifiable {
    func index(of element: Self.Iterator.Element) -> Self.Index? {
        return self.firstIndex { $0.id == element.id }
    }
}
