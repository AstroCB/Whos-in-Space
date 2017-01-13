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
        if #available(iOS 8.0, *) { // Checks to see whether opening settings is possible; if not, don't show the button to do so
        } else {
            self.pushLabel.text = "\(self.pushLabel.text) go to Settings."
            self.settingsButton.isHidden = true
        }
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openSettingsApp(_ sender: AnyObject) {
        if #available(iOS 8.0, *) {
            if let settingsURL: URL = URL(string: UIApplicationOpenSettingsURLString) { // Redundant check (just to make sure)
                UIApplication.shared.openURL(settingsURL)
            }
        }
    }
}
