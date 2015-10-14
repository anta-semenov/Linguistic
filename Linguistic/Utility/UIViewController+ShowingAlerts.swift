//
//  UIViewController+ShowingAlerts.swift
//  Linguistic
//
//  Created by Anton on 06/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertOkAction = UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction) -> Void in self.dismissViewControllerAnimated(true, completion: nil)})
        alert.addAction(alertOkAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
