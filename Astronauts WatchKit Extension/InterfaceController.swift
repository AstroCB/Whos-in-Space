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
    @IBOutlet var numberLabel: WKInterfaceLabel!
    var personMode: Bool = true
    var isHidden: Bool = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        // Add button to change to number mode
        self.addMenuItem(with: .add, title: "Number", action: #selector(InterfaceController.changeMode))
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
        if let request: Data = try? Data(contentsOf: URL(string: "http://api.open-notify.org/astros.json")!) {
            do {
                if let JSON: NSDictionary = try JSONSerialization.jsonObject(with: request, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if self.personMode {
                        // Table of astronauts
                        if let people: [[String: AnyObject]] = JSON.value(forKey: "people") as? [[String: AnyObject]] {
                            var names: [String] = [String]()
                            
                            for obj in people {
                                if let name: String = obj["name"] as? String {
                                    names.append(name)
                                }
                            }
                            
                            self.loadTableData(names)
                        }
                    } else {
                        // Single number
                        if let number: Int = JSON.value(forKey: "number") as? Int {
                            let font: UIFont = UIFont.systemFont(ofSize: 25)
                            let text: NSAttributedString = NSAttributedString(string: "\(number) astronauts are in space.", attributes: [NSFontAttributeName: font])
                            self.numberLabel.setAttributedText(text)
                        }
                    }
                }
            } catch _ {
                print("Error")
            }
        }
    }
    
    func loadTableData(_ data: [String]) {
        self.watchTable.setNumberOfRows(data.count, withRowType: "PersonRow")
        
        for (index, name) in data.enumerated() {
            if let row: TableRowController = watchTable.rowController(at: index) as? TableRowController {
                row.personLabel.setText(name)
            }
        }
    }
    
    @IBAction func changeMode() {
        // Remove old button
        self.clearAllMenuItems()
        // Hide/unhide table
        self.isHidden = !self.isHidden
        self.watchTable.setHidden(self.isHidden)
        // Switch mode
        self.personMode = !self.personMode
        // Hide/unhide number
        self.numberLabel.setHidden(!self.isHidden)
        // Refresh data
        self.refresh()
        // Add new button
        if self.personMode {
            self.addMenuItem(with: .add, title: "Number", action: #selector(InterfaceController.changeMode))
        } else {
            self.addMenuItem(with: .more, title: "People", action: #selector(InterfaceController.changeMode))
        }
    }
}
