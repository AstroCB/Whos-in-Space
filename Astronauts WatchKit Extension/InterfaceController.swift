//
//  InterfaceController.swift
//  Astronauts WatchKit Extension
//
//  Created by Cameron Bernhardt on 12/16/14.
//  Copyright (c) 2014 Cameron Bernhardt. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var watchTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        self.refresh()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func refresh() {
        if let request: NSData = NSData(contentsOfURL: NSURL(string: "http://api.open-notify.org/astros.json")!) {
            var error: NSError?
            if let JSON: NSDictionary = NSJSONSerialization.JSONObjectWithData(request, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary {
                if let people: [[String: AnyObject]] = JSON.valueForKey("people") as? [[String: AnyObject]] {
                    var names: [String] = [String]()
                    
                    for obj in people {
                        if let name: String = obj["name"] as? String {
                            names.append(name)
                        }
                    }
                    
                    self.loadTableData(names)
                }
                
            }
        }
    }
    
    func loadTableData(data: [String]) {
        self.watchTable.setNumberOfRows(data.count, withRowType: "PersonRow")
        
        for (index, name) in enumerate(data) {
            if let row: TableRowController = watchTable.rowControllerAtIndex(index) as? TableRowController {
                row.personLabel.setText(name)
            }
        }
    }
    
}
