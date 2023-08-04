//
//  Operators.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import Foundation
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

import UIKit


// MARK: - Filter

extension ObservableType {
  func filter<O: ObservableType>(_ predicate: O) -> Observable<Element> where O.Element == Bool {
    return self
      .withLatestFrom(predicate) { element, predicate in (element, predicate) }
      .filter { _, predicate in predicate }
      .map { element, _ in element }
  }

  func filterNot<O: ObservableType>(_ predicate: O) -> Observable<Element> where O.Element == Bool {
    return self
      .withLatestFrom(predicate) { element, predicate in (element, predicate) }
      .filter { _, predicate in !predicate }
      .map { element, _ in element }
  }
}
