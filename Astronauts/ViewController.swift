//
//  ViewController.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 7/15/14.
//  Copyright (c) 2014 Cameron Bernhardt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLConnectionDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loading.hidesWhenStopped = true
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        let JSON:NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return JSON
    }
    
    @IBOutlet weak var refresh: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var numPeople: UILabel!
    @IBOutlet weak var list: UILabel!
    @IBOutlet weak var descriptionText: UILabel!

    @IBAction func reload(){
        numPeople.hidden = true
        list.hidden = true
        descriptionText.hidden = true
        loadData();
    }
    
    func loadData(){
        loading.startAnimating()
        
        var request = getJSON("http://api.open-notify.org/astros.json")
        if(request != nil){
            var data = parseJSON(request)
            for (key, value) in data {
                if key as String == "number" {
                    numPeople.hidden = false
                    list.hidden = false
                    descriptionText.hidden = false
                    numPeople.text = String(value.integerValue)
                    list.text = ""
                    descriptionText.text = "astronauts are in space.\nThey are:"
                } else if key as String == "people" {
                    var counter:Int = 0;
                    for person in value as NSArray {
                        let name = person["name"] as String
                        let craft = person["craft"] as String
                        list.text = list.text + "\n\(name): \(craft)"
                        counter++
                    }
                    list.numberOfLines = (counter + 1) //dynamically set number of lines for label based on number of people it has to fit
                }
            }
        }else{
            descriptionText.hidden = false
            descriptionText.text = "Data currently unavailable.\nCheck your network connection."
        }
        
        loading.stopAnimating()
    }
}