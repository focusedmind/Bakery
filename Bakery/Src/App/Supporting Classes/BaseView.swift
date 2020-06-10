//
//  BaseView.swift
//  Bakery
//
//  Created by iOS Developer on 4/14/20.
//  Copyright © 2020 Bakery Union. All rights reserved.
//

import UIKit
import FTIndicator


protocol BaseView: class {
    
    func showActivityIndicator()
    func showActivityIndicator(_ message: String)
    func hideActivityIndicator()
    
    func showDialog(message: String, action: ((UIAlertAction) -> Void)?)
    func showChoiceDialog(message: String,
                          positiveMessage: String,
                          negativeMessage: String,
                          onChoice: @escaping (_ isPositive: Bool) -> Void)
    func showActionSheet(message: String,
                         titles: [String],
                         actions: [() -> Void])
    func showErrorDialog(message: String, action: ((UIAlertAction) -> Void)?, onShow: (() -> Void)?)
    func showFadingMessage(_ message: String, action: (() -> ())?)
    func showInfoMessage(_ message: String, action: (() -> ())?)
}


extension BaseView {
    
    func showActivityIndicator() {
        FTIndicator.showProgress(withMessage: "", userInteractionEnable: false)
    }
    
    func showActivityIndicator(_ message: String = "") {
        FTIndicator.showProgress(withMessage: message, userInteractionEnable: false)
    }
    
    func hideActivityIndicator() {
        FTIndicator.dismissProgress()
    }
    
    func showDialog(message: String, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Continue",
                                     style: UIAlertAction.Style.default,
                                     handler: action)
        alert.addAction(okAction)
        (self as? UIViewController)?.present(alert, animated: true)
    }
    
    
    func showChoiceDialog(message: String,
                          positiveMessage: String,
                          negativeMessage: String,
                          onChoice: @escaping (_ isPositive: Bool) -> Void) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        let positiveAction = UIAlertAction(title: positiveMessage,
                                           style: UIAlertAction.Style.default,
                                           handler: { _ in
                                            onChoice(true)
        })
//        positiveAction.setValue(#colorLiteral(red: 0.4860000014, green: 0.7179999948, blue: 0.3289999962, alpha: 1), forKey: "titleTextColor")
        let negativeAction = UIAlertAction(title: negativeMessage,
                                           style: UIAlertAction.Style.cancel,
                                           handler: { _ in
                                            onChoice(false)
        })
//        negativeAction.setValue(#colorLiteral(red: 0.4860000014, green: 0.7179999948, blue: 0.3289999962, alpha: 1), forKey: "titleTextColor")
        alert.addAction(negativeAction)
        alert.addAction(positiveAction)
        (self as? UIViewController)?.present(alert, animated: true)
    }
    
    func showActionSheet(message: String,
                         titles: [String],
                         actions: [() -> Void]) {
        guard titles.count == actions.count else {
            return
        }
        let sheet = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        for i in 0..<titles.count {
            let button = UIAlertAction(title: titles[i],
                                       style: UIAlertAction.Style.default,
                                       handler: { [i, actions] _ in actions[i]() })
//            button.setValue(#colorLiteral(red: 0.4860000014, green: 0.7179999948, blue: 0.3289999962, alpha: 1), forKey: "titleTextColor")
            sheet.addAction(button)
        }
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.cancel,
                                         handler: nil)
//        cancelButton.setValue(#colorLiteral(red: 0.4860000014, green: 0.7179999948, blue: 0.3289999962, alpha: 1), forKey: "titleTextColor")
        sheet.addAction(cancelButton)
        (self as? UIViewController)?.present(sheet, animated: true)
    }
    
    func showErrorDialog(message: String,
                         action: ((UIAlertAction) -> Void)? = nil,
                         onShow: (() -> Void)? = nil) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alert = UIAlertController(title: "Error",
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "Continue",
                                         style: UIAlertAction.Style.default,
                                         handler: action)
            alert.addAction(okAction)
            (self as? UIViewController)?.present(alert, animated: true, completion: onShow)
        }
    }
    
    
    func showFadingMessage(_ message: String, action: (() -> ())? = nil) {
        FTIndicator.showInfo(withMessage: message, userInteractionEnable: false)
        guard let action = action else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            action()
        }
    }
    
    func showInfoMessage(_ message: String, action: (() -> ())?) {
        FTIndicator.showInfo(withMessage: message, userInteractionEnable: false)
        guard let action = action else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            action()
        }
    }
}
