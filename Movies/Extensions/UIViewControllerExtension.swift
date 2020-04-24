//
//  UIViewControllerExtension.swift
//  Movies
//
//  Created by Miran Hrupački on 24/04/2020.
//  Copyright © 2020 Miran Hrupački. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlertWith(title: String, message: String){
        let alert: UIAlertController = {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            return alert
        }()
        self.present(alert, animated: true, completion: nil)
    }
}
