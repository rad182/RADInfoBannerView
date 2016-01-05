//
//  RADInfoBannerView.swift
//  RADInfoBannerView
//
//  Created by Royce Albert Dy on 23/12/2015.
//  Copyright © 2015 Royce Albert Dy. All rights reserved.
//

import UIKit

private let RADInfoBannerViewWithNavigationBarHeight: CGFloat = 30.0
private let RADInfoBannerViewWithoutNavigationBarHeight: CGFloat = 50.0

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
        if let navigationController = self.topViewController as? UINavigationController {
            if navigationController.navigationBarHidden == false {
                topOffset = 20.0 + CGRectGetHeight(navigationController.navigationBar.frame) // 20 px for status bar + navigation bar height
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
            NSLayoutConstraint(item: self.textLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: -8.0),
            NSLayoutConstraint(item: self.textLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        ])
        
        super.updateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Methods
    private func infoBannerViewHeight() -> CGFloat {
        if let navigationController = self.topViewController?.parentViewController as? UINavigationController {
            return navigationController.navigationBarHidden ? RADInfoBannerViewWithoutNavigationBarHeight : RADInfoBannerViewWithNavigationBarHeight
        }
        return RADInfoBannerViewWithNavigationBarHeight
    }
    
    // MARK: Public Methods
    public func show(inController topViewController: UIViewController? = UIApplication.topViewController()) -> Self {
        // get top view controller
        guard let topViewController = topViewController else {
            fatalError("no top view controller detected")
        }
        self.topViewController = topViewController
        
        // first remove all banners
        RADInfoBannerView.hideAllInfoBannerViewInView(topViewController.view)
        
        // add to view
        topViewController.view.addSubview(self)
        topViewController.view.layoutIfNeeded()
        topViewController.view.updateConstraintsIfNeeded()
        // compute the correct height of the info banner view
        self.heightConstraint.constant = self.infoBannerViewHeight()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.layoutIfNeeded()
        })
        
        return self
    }
    
    public func hide(afterDelay delay: Double = 0.0) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // set height back to 0
            self.heightConstraint.constant = 0.0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.layoutIfNeeded()
            }, completion: { (finished) -> Void in
                self.removeFromSuperview()
            })
        }
    }
    
    public class func showInfoBannerView(text: String, showActivityIndicatorView: Bool = false, hideAfter delay: Double = 3.0) -> RADInfoBannerView {
        let infoBannerView = RADInfoBannerView(text: text, showActivityIndicatorView: showActivityIndicatorView)
        infoBannerView.show().hide(afterDelay: delay)
        return infoBannerView
    }
    
    public class func hideAllInfoBannerViewInView(view: UIView) {
        for view in view.subviews where view is RADInfoBannerView {
            (view as! RADInfoBannerView).hide()
        }
    }
    
}
