//
//  InterfaceController.swift
//  Astronauts WatchKit Extension
//
//  Created by Cameron Bernhardt on 12/16/14.
//  Copyright (c) 2014 Cameron Bernhardt. All rights reserved.
//

import WatchKit
import Foundation

// JSON decoding classes
struct SpaceInfo: Decodable {
    let number: Int
    let people: [Person]
    let message: String
}

struct Person: Decodable {
    let craft: String
    let name: String
}

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
        guard let url: URL = URL(string: "http://api.open-notify.org/astros.json") else { return }
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let error: Error = err {
                print("Error making request: \(error.localizedDescription)")
            } else if let response: HTTPURLResponse = res as? HTTPURLResponse, response.statusCode != 200 {
                print("Error receiving response: status code \(response.statusCode)")
            } else if let rData: Data = data {
                do {
                    let info: SpaceInfo = try JSONDecoder().decode(SpaceInfo.self, from: rData)
                    print(info.people)
                    if self.personMode {
                        // Table of astronauts
                        self.loadTableData(info.people)
                    } else {
                        // Single number
                        let font: UIFont = UIFont.systemFont(ofSize: 25)
                        let text: NSAttributedString = NSAttributedString(string: "\(info.number) astronauts are in space.", attributes: [NSAttributedStringKey.font: font])
                        self.numberLabel.setAttributedText(text)
                    }
                } catch let jsonErr  {
                    print("Error serializing JSON from request: \(jsonErr.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func loadTableData(_ data: [Person]) {
        self.watchTable.setNumberOfRows(data.count, withRowType: "PersonRow")
        
        for (index, person) in data.enumerated() {
            if let row: TableRowController = watchTable.rowController(at: index) as? TableRowController {
                row.personLabel.setText(person.name)
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
