//
//  TableViewController.swift
//  WOWTableRefresherDemo
//
//  Created by Zhou Hao on 17/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var data = [String]()
    var refreshControl : WOWRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupRefresher()
    }

    func setupRefresher() {

        refreshControl = WOWRefreshControl(scrollView: self.tableView, direction: .vertical, readyToRefresh: { () -> Void in
            self.reloadData()
        })
        refreshControl.lineWidth = 5
        refreshControl.lineColor = UIColor.blueColor()
        refreshControl.backgroundColor = UIColor.yellowColor()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if data.count == 0 {
         
            // Display a message when the table is empty
            let messageLabel = UILabel(frame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            
            messageLabel.text = "No data is currently available. Please pull down to refresh."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center;
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            messageLabel.sizeToFit()
            
            self.tableView.backgroundView = messageLabel
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func reloadData() {
    
        let delayInSeconds = 3.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in

            self.data.append("Hello")
            self.data.append("Good")
            self.data.append("Nice")
            self.data.append("That")
            self.data.append("This")
            self.data.append("Data")
            self.data.append("Get")
            self.data.append("Time")
            
            self.tableView.reloadData()
            self.refreshControl.stopRefresh()
        }

    }
}

