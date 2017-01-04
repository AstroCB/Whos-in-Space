//
//  TodayViewController.swift
//  Who's in Space?
//
//  Created by Cameron Bernhardt on 1/1/15.
//  Copyright (c) 2015 Cameron Bernhardt. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var number: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() -> String? {
        let data: NSData? = NSData(contentsOfURL: NSURL(string: "http://api.open-notify.org/astros.json")!)
        
        if let req = data {
            var parsedData: NSDictionary?
            do {
                if let JSON: NSDictionary = try NSJSONSerialization.JSONObjectWithData(req, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    parsedData = JSON
                }
                
                if let newData: NSDictionary = parsedData {
                    if let number: Int = newData.valueForKey("number") as? Int {
                        return "\(number) astronauts are in space"
                    }
                }
            } catch _ {
                print("Error")
            }
        }
        return nil
    }
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        if let numPeople: String = self.getData() {
            if numPeople == self.number.text {
                completionHandler(NCUpdateResult.NoData)
            } else {
                self.number.text = numPeople
                completionHandler(NCUpdateResult.NewData)
            }
        } else {
            completionHandler(NCUpdateResult.Failed)
        }
    }
    
}
