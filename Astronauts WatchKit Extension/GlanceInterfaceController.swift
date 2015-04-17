//
//  GlanceController.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 3/16/15.
//  Copyright (c) 2015 Cameron Bernhardt. All rights reserved.
//

import WatchKit
import Foundation


class GlanceInterfaceController: WKInterfaceController {
    
    @IBOutlet var numberLabel: WKInterfaceLabel!
    @IBOutlet var infoLabel: WKInterfaceLabel!
    @IBOutlet var tapLabel: WKInterfaceLabel!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        self.getData()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getData() {
        // Pull from defaults to avoid extraneous network calls
        if let defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.Astronauts") {
            if let number: Int = defaults.objectForKey("number") as? Int {
                self.infoLabel.setHidden(true)
                                self.tapLabel.setHidden(true)
                let font: UIFont = UIFont.systemFontOfSize(105)
                let attrString: NSAttributedString = NSAttributedString(string: "\(number)", attributes: [NSFontAttributeName: font])
                self.numberLabel.setAttributedText(attrString)
                self.numberLabel.setHidden(false)
            } else {
                self.numberLabel.setHidden(true)
                var font: UIFont = UIFont.systemFontOfSize(15)
                var attrString: NSAttributedString = NSAttributedString(string: "Tap to open", attributes: [NSFontAttributeName: font])
                self.tapLabel.setAttributedText(attrString)
                self.tapLabel.setHidden(false)
                font = UIFont.systemFontOfSize(10)
                attrString = NSAttributedString(string: "It looks like you haven't loaded this information yet.", attributes: [NSFontAttributeName: font])
                self.infoLabel.setAttributedText(attrString)
                self.infoLabel.setHidden(false)
            }
        }
    }
}
