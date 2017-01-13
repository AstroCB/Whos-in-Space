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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
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
        if let request: Data = try? Data(contentsOf: URL(string: "http://api.open-notify.org/astros.json")!) {
            do {
            if let JSON: NSDictionary = try JSONSerialization.jsonObject(with: request, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                if let number: Int = JSON.value(forKey: "number") as? Int {
                    let font: UIFont = UIFont.systemFont(ofSize: 135)
                    let attrString: NSAttributedString = NSAttributedString(string: "\(number)", attributes: [NSFontAttributeName: font])
                    self.numberLabel.setAttributedText(attrString)
                }
            }
            } catch _ {
                print("Error")
            }
        } else {
            print("Check network connection.")
        }
    }
}
