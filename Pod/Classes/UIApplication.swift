//
//  UIApplication.swift
//  Pods
//
//  Created by Royce Albert Dy on 05/11/2015.
//  Copyright © 2015 Royce Albert Dy. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}