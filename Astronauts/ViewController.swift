//
//  ViewController.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 7/15/14.
//  Copyright (c) 2014 Cameron Bernhardt. All rights reserved.
//

import UIKit
import iAd

class ViewController: UIViewController, NSURLConnectionDelegate, ADBannerViewDelegate {
    let height: CGFloat = UIScreen.mainScreen().bounds.size.height //grab screen size
    let width: CGFloat = UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let refresh = UIButton.buttonWithType(UIButtonType.System) as UIButton //create refresh button
        
        refresh.frame = CGRectMake(110, height/1.23, 100, 50)
        refresh.titleLabel?.font = UIFont(name: "Arial", size: 15)
        refresh.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
        refresh.setTitle("Refresh", forState: UIControlState.Normal)
        refresh.addTarget(self, action: "reload:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(refresh)
        
        loadData()
        
        self.canDisplayBannerAds = true
        self.ad.delegate = self
        self.ad.alpha = 0.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary {
        var error: NSError?
        let JSON:NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return JSON
    }
    
    let descriptionText = UILabel()
    let ad = ADBannerView()
    let numPeople = UILabel()
    
    
    var urls:[String] = [] //holds URLs for astronauts
    var ind:Int = 0 //give each astronaut an ID to keep track
    var buttons:[UIButton] = []
    
    func reload(sender:UIButton!){
        numPeople.hidden = true
        descriptionText.hidden = true
        
        for(var i = 0; i < ind; i++){ //remove all of the buttons
            buttons[i].removeFromSuperview()
        }
        
        buttons = []
        
        ind = 0
        
        loadData()
    }
    
    func labelTapped(sender:UIButton!) { //handles button clicks
        let urlIndex = sender.tag
        if (urlIndex >= 0 && urlIndex < self.urls.count) {
            openUrl(urls[urlIndex])
        }
    }
    
    func openUrl(url:String!) { //opens URLs
        let targetURL = NSURL.URLWithString(url)
        
        let application = UIApplication.sharedApplication()
        
        application.openURL(targetURL);
        
    }
    
    func loadData(){
        var request:NSData? = getJSON("http://api.open-notify.org/astros.json")
        
        var x:CGFloat = 10, y:CGFloat = height/2.3 //positions
        
        if(request != nil){
            var data = parseJSON(request!)
            for (key, value) in data {
                if key as String == "number" {
                    numPeople.hidden = false
                    descriptionText.hidden = false
                    let num:Int = value.integerValue
                    
                    numPeople.text = String(num)
                    numPeople.textColor = UIColor.whiteColor()
                    numPeople.font = UIFont(name: "Arial", size: 100)
                    numPeople.frame = CGRectMake(130, 0, 100, 273)
                    
                    descriptionText.textColor = UIColor.whiteColor()
                    descriptionText.frame = CGRectMake(25, height/2.9, 275, 50)
                    descriptionText.textAlignment = NSTextAlignment.Center
                    descriptionText.numberOfLines = 2
                    descriptionText.text = "astronauts are in space.\nThey are:"
                    
                    self.view.addSubview(numPeople)
                    self.view.addSubview(descriptionText)
                } else if key as String == "people" {
                    for person in value as NSArray {
                        let name = person["name"] as String //name of astronaut
                        let craft = person["craft"] as String //location of astronaut
                        
                        var encodedURL = ""
                        
                        for j in name {
                            if j == " " {
                                encodedURL = encodedURL + "+"
                            } else {
                                encodedURL = encodedURL + (String(j))
                            }
                        }
                        
                        urls.append("http://google.com/search?q=" + encodedURL)
                        
                        //create a button for each astronaut
                        let button = UIButton.buttonWithType(UIButtonType.System) as UIButton
                        
                        button.tag = ind
                        button.frame = CGRectMake(x, y, 300, 30)
                        button.titleLabel?.font = UIFont(name: "Arial", size: 17)
                        button.setTitleColor(UIColor.whiteColor(), forState:UIControlState.Normal)
                        button.setTitle("\(name): \(craft)", forState: UIControlState.Normal)
                        button.addTarget(self, action: "labelTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                        
                        buttons.append(button)
                        
                        self.view.addSubview(button)
                        
                        y += 30 //move each button down
                        
                        ind++
                    }
                }
            }
        }else{
            descriptionText.hidden = false
            descriptionText.text = "Data currently unavailable.\nCheck your network connection."
        }
    }
}