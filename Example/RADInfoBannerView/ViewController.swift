//
//  ViewController.swift
//  RADInfoBannerView
//
//  Created by Royce Dy on 12/23/2015.
//  Copyright (c) 2015 Royce Dy. All rights reserved.
//

import UIKit
import RADInfoBannerView

class ViewController: UIViewController {

    @IBOutlet weak var navigationBarSwitch: UISwitch!
    @IBOutlet weak var activityIndicatorSwitch: UISwitch!
    @IBOutlet weak var messageText: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapView")
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func didTapView() {
        // hide keyboard
        self.messageText.resignFirstResponder()
    }
    
    // MARK: IBActions
    @IBAction func navigationBarSwitchValueDidChange() {
        self.navigationController?.setNavigationBarHidden(!self.navigationBarSwitch.on, animated: true)
    }
    
    @IBAction func didTapShowInfoBannerViewButton() {
        if let text = self.messageText.text where text.isEmpty == false {
            RADInfoBannerView.showInfoBannerView(text, showActivityIndicatorView: self.activityIndicatorSwitch.on, hideAfter: 3.0)
        }
    }
    
    @IBAction func didTapShowCustomInfoBannerViewColorButton() {
        if let text = self.messageText.text where text.isEmpty == false {
            let infoBannerView = RADInfoBannerView(text: text, showActivityIndicatorView: self.activityIndicatorSwitch.on)
            infoBannerView.backgroundColor = .redColor()
            infoBannerView.textLabel.textColor = .yellowColor()
            infoBannerView.show().hide(afterDelay: 3.0)
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

