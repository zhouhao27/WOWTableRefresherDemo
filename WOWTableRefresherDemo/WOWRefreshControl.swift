//
//  WOWRefreshControl.swift
//  WOWTableRefresherDemo
//
//  Created by Zhou Hao on 17/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

public class WOWRefreshControl: UIRefreshControl {

    public typealias CompletionHandler = () -> Void
    
    public var completionHandler : CompletionHandler?
    private var refreshLoadingView : UIView!
    private var rippleIndicator : WOWRippleIndicator!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        setup()
    }

    override init() {
        super.init()
        
        setup()
    }
    
    init(readyToRefresh handler:CompletionHandler?) {
        super.init()
        
        completionHandler = handler
        setup()
    }
    
    func setup() {
        
        addTarget(self, action: "onReadyToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        // hide the original spinner
        self.tintColor = UIColor.clearColor()
        
        // size not decided yet
        // loading view to cover the default view
        refreshLoadingView = UIView()
        addSubview(refreshLoadingView)
        refreshLoadingView.backgroundColor = UIColor.lightGrayColor()
        
        rippleIndicator = WOWRippleIndicator()
        rippleIndicator.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(40, 40))
        rippleIndicator.backgroundColor = UIColor.clearColor()
        rippleIndicator.alpha = 0
        rippleIndicator.degree = 0
        refreshLoadingView.addSubview(rippleIndicator)

    }
    
    func onReadyToRefresh() {
        
        print("refresh bounds = \(self.bounds)")
        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "MMM d, h:mm a"
//
//        let title = String("Last update: \(formatter.stringFromDate(NSDate()))")
//        let attributedTitle = NSAttributedString(string: title)
//        self.attributedTitle = attributedTitle;
        
        rippleIndicator.startAnimation()
        if completionHandler != nil {
            completionHandler!()
        }
    }
    
    public func update() {
        
        let pullDistance = max(0.0, -self.frame.origin.y);
        var refreshBounds = self.bounds
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        refreshLoadingView.frame = refreshBounds;
        
        if pullDistance >= rippleIndicator.bounds.height {

            let center = CGPointMake(refreshLoadingView.center.x - rippleIndicator.bounds.width / 2, refreshLoadingView.center.y - rippleIndicator.bounds.height / 2)
            rippleIndicator.frame = CGRect(origin: center, size: rippleIndicator.bounds.size)
            
            let value = (pullDistance - rippleIndicator.bounds.size.height) / rippleIndicator.bounds.size.height
            let percentage = min(1,value)
            
            rippleIndicator.alpha = percentage
            rippleIndicator.degree = percentage
            
        } else {
            
            rippleIndicator.alpha = 0
            rippleIndicator.degree = 0
        }
        
        if refreshing {
            rippleIndicator.alpha = 1
            rippleIndicator.degree = 0
        }
    }
    
    public func stopRefresh() {
        
        self.endRefreshing()
        self.rippleIndicator.stopAnimation()
    }
    
}
