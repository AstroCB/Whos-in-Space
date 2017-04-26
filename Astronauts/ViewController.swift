//
//  ViewController.swift
//  Astronauts
//
//  Created by Cameron Bernhardt on 7/15/14.
//  Copyright (c) 2014 Cameron Bernhardt. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    let height: CGFloat = UIScreen.main.bounds.size.height // Grab screen size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initial load
        self.loadData()
        
        let refresh: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(ViewController.share))
        refresh.tintColor = UIColor.white
        
        let gear: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Gear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.openSettings))
        gear.tintColor = UIColor.white
        
        let rightButtons: [UIBarButtonItem] = [refresh, gear]
        self.navigationItem.rightBarButtonItems = rightButtons
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(_ urlToRequest: String) -> Data? {
        return (try? Data(contentsOf: URL(string: urlToRequest)!))
    }
    
    func parseJSON(_ inputData: Data) -> NSDictionary? {
        do {
            if let JSON: NSDictionary = try JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                return JSON
            }
        } catch _ {
            print("Error parsing")
        }
        
        return nil
    }
    
    @IBOutlet weak var numPeople: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var trailText: UILabel!
    var connected: Bool = false
    
    
    var urls: [String] = [] // Holds URLs for astronauts
    var ind: Int = 0 // Give each astronaut an ID to keep track
    var buttons: [UIButton] = []
    
    @IBAction func reload() {
        numPeople.isHidden = true
        descriptionText.isHidden = true
        
        for i in buttons { // Remove all of the buttons
            i.removeFromSuperview()
        }
        
        buttons = []
        
        ind = 0
        
        loadData()
    }
    
    func labelTapped(_ sender: UIButton!) { // Handles button clicks
        let urlIndex = sender.tag
        self.openUrl(urls[urlIndex])
    }
    
    func openUrl(_ url: String!) { // Opens URLs
        let targetURL = URL(string: url)!
        if #available(iOS 9.0, *) { // Use SFSafariViewController if available
            let svc: SFSafariViewController = SFSafariViewController(url: targetURL)
            svc.delegate = self
            self.present(svc, animated: true, completion: nil)
        } else { // Just open in Safari
            UIApplication.shared.openURL(targetURL)
        }
    }
    
    func loadData(){
        // Multipliers for constraint positioning later
        var constMultiplier: CGFloat = 1
        var topConst: CGFloat = 1.1
        
        // Fiddle with positioning based on device size; this is bad style, but I don't know a better way
        switch height {
        case 480: // 4s
            constMultiplier = 1.03
            topConst = 1.05
        case 568: // 5/s
            constMultiplier = 1.05
        case 667: // 6/7/s
            constMultiplier = 1.08
        case 736: // 6/7/s Plus
            constMultiplier = 1.1
        default: // ??
            constMultiplier = 1.05
        }
        
        if let request: Data = getJSON("http://api.open-notify.org/astros.json") {
            self.connected = true
            let data: NSDictionary = parseJSON(request)!
            self.numPeople.isHidden = false
            self.descriptionText.isHidden = false
            self.trailText.isHidden = false
            
            if let num: Int = (data.value(forKey: "number") as AnyObject).intValue {
                numPeople.text = "\(num)"
                
                // Save to defaults
                if let defaults: UserDefaults = UserDefaults(suiteName: "group.Astronauts") {
                    defaults.set(num, forKey: "number")
                    defaults.synchronize()
                }
            }
            
            if let value: [NSDictionary] = data.value(forKey: "people") as? [NSDictionary] {
                for person in value {
                    let name: String = person["name"] as! String // Name of astronaut
                    let craft: String = person["craft"] as! String // Location of astronaut
                    
                    var encodedURL = ""
                    
                    for j in name.characters {
                        if j == " " {
                            encodedURL = encodedURL + "+"
                        } else {
                            encodedURL = encodedURL + (String(j))
                        }
                    }
                    
                    urls.append("https://google.com/search?q=" + encodedURL)
                    
                    // Create a button for each astronaut
                    let button = UIButton(type: UIButtonType.system)
                    
                    button.tag = ind
                    button.titleLabel?.font = UIFont(name: "Arial", size: 17)
                    button.setTitleColor(UIColor.white, for:UIControlState())
                    button.setTitle("\(name): \(craft)", for: UIControlState())
                    button.addTarget(self, action: #selector(ViewController.labelTapped(_:)), for: UIControlEvents.touchUpInside)
                    
                    buttons.append(button)
                    
                    self.view.addSubview(button)
                    
                    // Positioning and constraints for buttons
                    button.translatesAutoresizingMaskIntoConstraints = false
                    
                    let constX = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
                    self.view.addConstraint(constX)
                    
                    if ind == 0 {
                        let constY = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self.trailText, attribute: .centerY, multiplier: topConst, constant: 0)
                        self.view.addConstraint(constY)
                    } else {
                        let lastButton: UIButton = self.buttons[ind - 1]
                        let constY = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: lastButton, attribute: .centerY, multiplier: constMultiplier, constant: 0)
                        self.view.addConstraint(constY)
                    }
                    
                    ind += 1
                }
            }
        } else { // No connection...or the API has been taken down, which would be bad (and possibly my fault)
            numPeople.isHidden = true
            descriptionText.isHidden = true
            trailText.isHidden = true
            connected = false
            DispatchQueue.main.async(execute: {
                alert("Data currently unavailable.", message: "Check your network connection.", controller: self)
            })
            
        }
    }
    
    // Sharing
    @IBAction func share() {
        if connected {
            if let number: String = numPeople.text {
                let message: String = "There are currently \(number) people in space!"
                
                if let myWebsite = URL(string: "https://cameronbernhardt.com/projects/whos-in-space/") {
                    let objectsToShare: [AnyObject] = [message as AnyObject, myWebsite as AnyObject]
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                    
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        } else {
            alert("No connection.", message: "Why share what you don't have?", controller: self)
        }
    }
    
    func openSettings() {
        self.performSegue(withIdentifier: "openSettings", sender: self)
    }
    
    @available(iOS 9.0, *)
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

public func alert(_ title: String, message: String, controller: UIViewController) {
    if #available(iOS 8.0, *) { // UIAlertController is available
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    } else { // Not available; use UIAlertView
        let alert: UIAlertView = UIAlertView()
        alert.delegate = controller
        
        alert.title = title
        alert.message = message
        alert.addButton(withTitle: "OK")
        
        alert.show()
    }
}
