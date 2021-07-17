//
//  UITableView+Extension.swift
//  NYTimes
//
//  Created by Mannan on 16/07/2021.
//

import Foundation
import UIKit

extension UITableView {
    
    /// This method is used to show loader
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .medium)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }

    /// This method is used to hide loader
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}
