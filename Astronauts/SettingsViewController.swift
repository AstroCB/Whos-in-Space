//
//  SettingsViewController.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 1/19/15.
//  Copyright (c) 2015 Cameron Bernhardt. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var pushLabel: UITextView!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewDidLoad() {
        if let settingsURL: NSURL = NSURL(string: UIApplicationOpenSettingsURLString) { // Checks to see whether opening settings is possible; if not, don't show the button to do so
        } else {
            self.pushLabel.text = "\(self.pushLabel.text) go to Settings."
            self.settingsButton.hidden = true
        }
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func openSettingsApp(sender: AnyObject) {
        if let settingsURL: NSURL = NSURL(string: UIApplicationOpenSettingsURLString) { // Redundant check (just to make sure)
        UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
    
    func alert(title: String, message: String) {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            
            alert.title = title
            alert.message = message
            alert.addButtonWithTitle("OK")
            
            alert.show()
        }
    }
}