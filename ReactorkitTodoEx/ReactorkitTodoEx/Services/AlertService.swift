//
//  AlertService.swift
//  ReactorkitTodoEx
//
//  Created by yangjs on 2023/08/01.
//

import Foundation
import UIKit
import URLNavigator
import RxSwift

protocol AlertActionType {
    var title: String? { get }
    var style: UIAlertAction.Style { get }
}

extension AlertActionType {
    var style: UIAlertAction.Style {
        return .default
    }
}

protocol AlertServiceType: AnyObject {
    func show<Action: AlertActionType> (
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions:[Action]
    ) -> Observable<Action>
}


final class AlertService: BaseService, AlertServiceType {
    func show<Action: AlertActionType> (
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions:[Action]
    ) -> Observable<Action> {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            for action in actions {
                let alertAction = UIAlertAction(
                    title: action.title,
                    style: action.style
                ) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alert.addAction(alertAction)
                
            }
            Navigator().present(alert)
            return Disposables.create {
                alert.dismiss(animated: true)
            }
            
        }
    }
}
