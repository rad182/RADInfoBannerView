//
//  RADInfoBannerView.swift
//  RADInfoBannerView
//
//  Created by Royce Albert Dy on 23/12/2015.
//  Copyright © 2015 Royce Albert Dy. All rights reserved.
//

import UIKit

private let RADInfoBannerViewHeight: CGFloat = 30.0
private let RADInfoBannerViewHeightPadding: CGFloat = 10.0

/// Simple and Customizable Dropdown banner below Navigation Bar
public class RADInfoBannerView: UIView {
    
    public let textLabel = UILabel()
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    private var topLayoutConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var topViewController: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.font = UIFont.systemFontOfSize(14.0)
        self.textLabel.textAlignment = .Center
        self.textLabel.textColor = UIColor.whiteColor()
        self.textLabel.numberOfLines = 0
        self.addSubview(self.textLabel)
        
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.activityIndicatorView)
    }
    
    public convenience init(text: String, showActivityIndicatorView: Bool = false) {
        self.init()
        self.textLabel.text = text
        if showActivityIndicatorView {
            self.activityIndicatorView.startAnimating()
        } else {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    override public func updateConstraints() {
        var topOffset: CGFloat = 0.0
        
        if self.topViewController?.edgesForExtendedLayout == .All || self.topViewController?.edgesForExtendedLayout == .Top {
            topOffset += 20.0 // add status bar height
            if let navigationController = self.topViewController?.parentViewController as? UINavigationController {
                if navigationController.navigationBarHidden == false {
                    topOffset += CGRectGetHeight(navigationController.navigationBar.frame)
                }
            }
        }
        
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)

        NSLayoutConstraint.activateConstraints([
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: self.superview, attribute: .Top, multiplier: 1.0, constant: topOffset),
            NSLayoutConstraint(item: self, attribute: .Leading, relatedBy: .Equal, toItem: self.superview, attribute: .Leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self, attribute: .Trailing, relatedBy: .Equal, toItem: self.superview, attribute: .Trailing, multiplier: 1.0, constant: 0.0),
            self.heightConstraint,
            
            // activityIndicator
            NSLayoutConstraint(item: self.activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: self.textLabel, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.activityIndicatorView, attribute: .Right, relatedBy: .Equal, toItem: self.textLabel, attribute: .Left, multiplier: 1.0, constant: -5.0),
            
            // textLabel
            NSLayoutConstraint(item: self.textLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: self.textLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.textLabelSize().width)
        ])
        
        super.updateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    /**
    Shows the Info Banner View
    
    - parameter topViewController: the view controller you want to specifically show
    
    - returns: The current Info Banner View
    */
    public func show(inController topViewController: UIViewController? = nil) -> Self {
        // get top view controller
        if let topViewController = topViewController {
            self.topViewController = topViewController
        } else {
            self.topViewController = RADInfoBannerView.topViewController()
        }
        
        // first remove all banners
        RADInfoBannerView.hideAllInfoBannerView(inController: self.topViewController)
        
        // add to view
        self.topViewController!.view.addSubview(self)
        self.topViewController!.view.layoutIfNeeded()
        self.topViewController!.view.updateConstraintsIfNeeded()
        // set height of the info banner view
        self.heightConstraint.constant = self.infoBannerViewHeight()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.layoutIfNeeded()
        })
        
        return self
    }
    
    /**
     Hide the Info Banner View
     
     - parameter delay:    the delay before it will dismissed
     - parameter animated: boolean if you want to hide if animated or not
     */
    public func hide(afterDelay delay: Double? = nil, animated: Bool = true) {
        if let delay = delay {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.hideInfoBannerView(animated)
            }
        } else {
            self.hideInfoBannerView(animated)
        }
    }
    
    /**
     Creates an Info Banner View and Displays the Info Banner
     
     - parameter text:                      the message you want to show
     - parameter showActivityIndicatorView: boolean if you want to show activity indicator
     - parameter delay:                     the delay before it will dismissed
     - parameter topViewController:         the view controller you want to specifically show
     
     - returns: The created info banner view
     */
    public class func showInfoBannerView(text: String, showActivityIndicatorView: Bool = false, hideAfter delay: Double? = nil, inController topViewController: UIViewController? = nil) -> RADInfoBannerView {
        let infoBannerView = RADInfoBannerView(text: text, showActivityIndicatorView: showActivityIndicatorView)
        infoBannerView.show(inController: topViewController)
        if let delay = delay {
            infoBannerView.hide(afterDelay: delay)
        }
        return infoBannerView
    }
    
    /**
     Hides all the Info Banner View
     
     - parameter topViewController: the view controller you want to specifcally hide all the info banner view
     - parameter animated:          boolean if you want to hide if animated or not
     */
    public class func hideAllInfoBannerView(inController topViewController: UIViewController? = nil, animated: Bool = true) {
        var viewController: UIViewController!
        if let topViewController = topViewController {
            viewController = topViewController
        } else {
            viewController = RADInfoBannerView.topViewController()
        }
        
        for view in viewController.view.subviews where view is RADInfoBannerView {
            (view as! RADInfoBannerView).hide(animated: animated)
        }
    }
    
}

extension RADInfoBannerView {
    // MARK: Private Methods
    func infoBannerViewHeight() -> CGFloat {
        let calculatedHeight = self.textLabelSize().height + RADInfoBannerViewHeightPadding
        return calculatedHeight > RADInfoBannerViewHeight ? calculatedHeight : RADInfoBannerViewHeight
    }
    
    func textLabelSize() -> CGSize {
        let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
        let constraintWidth = self.activityIndicatorView.isAnimating() ? screenWidth * 0.82 : screenWidth * 0.9
        let constraintSize = CGSize(width: constraintWidth, height: CGFloat.max)
        return self.textLabel.sizeThatFits(constraintSize)
    }
    
    func hideInfoBannerView(animated: Bool = true) {
        // if already removed then just return
        guard let _ = self.superview else {
            return
        }
        
        if animated {
            // set height back to 0
            self.heightConstraint.constant = 0.0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.superview!.layoutIfNeeded()
                }, completion: { (finished) -> Void in
                    self.removeFromSuperview()
            })
        } else {
            self.removeFromSuperview()
        }
    }
    
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
