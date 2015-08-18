//
//  WOWRefreshControl.swift
//  WOWTableRefresherDemo
//
//  Created by Zhou Hao on 17/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

public class WOWRefreshControl: UIRefreshControl {
    
    let kIndicatorWidth : CGFloat = 40.0
    
    public typealias CompletionHandler = () -> Void
    
    public var completionHandler : CompletionHandler?
    public var lineWidth : CGFloat = 2.0
    public var lineColor : UIColor = UIColor.blackColor()
    
    private var refreshLoadingView : UIView!
    private var rippleIndicator : WOWRippleIndicator?
    
    override public var backgroundColor : UIColor?  {
        didSet {
            refreshLoadingView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: life circle
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
    
    // MARK: methods
    func setup() {
        
        addTarget(self, action: "onReadyToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        // hide the original spinner
        self.tintColor = UIColor.clearColor()
        
        // size not decided yet
        // loading view to cover the default view
        refreshLoadingView = UIView()
        addSubview(refreshLoadingView)
    }
    
    func onReadyToRefresh() {
        
        if rippleIndicator != nil {
            rippleIndicator!.startAnimation()
        }
        if completionHandler != nil {
            completionHandler!()
        }
    }
    
    func createIndicator() {

        if rippleIndicator == nil {
            rippleIndicator = WOWRippleIndicator()
            rippleIndicator!.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(kIndicatorWidth, kIndicatorWidth))
            rippleIndicator!.backgroundColor = UIColor.clearColor()
            rippleIndicator!.degree = 0
            rippleIndicator!.rippleColor = self.lineColor
            rippleIndicator!.rippleLineWidth = self.lineWidth
            refreshLoadingView.addSubview(rippleIndicator!)
        }
    }
    
    func removeIndicator() {
        
        if rippleIndicator != nil {
            
            rippleIndicator!.removeFromSuperview()
            rippleIndicator = nil
        }
    }
    
    public func update() {
        
        let pullDistance = max(0.0, -self.frame.origin.y);
        var refreshBounds = self.bounds
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        refreshLoadingView.frame = refreshBounds;
                
        if pullDistance >= kIndicatorWidth {

            createIndicator()

            let center = CGPointMake(refreshLoadingView.center.x - kIndicatorWidth / 2, refreshLoadingView.center.y - kIndicatorWidth / 2)
            rippleIndicator!.frame = CGRect(origin: center, size: rippleIndicator!.bounds.size)
            
            let value = (pullDistance - kIndicatorWidth) / kIndicatorWidth
            let percentage = min(1,value)
            
            rippleIndicator!.degree = percentage
            
            if refreshing {
                rippleIndicator!.degree = 0
            }
            
        } else {
            
            // remove
            removeIndicator()
        }
        
    }
    
    public func stopRefresh() {
        self.endRefreshing()
        if rippleIndicator != nil {
            rippleIndicator!.stopAnimation()
        }
    }
    
}
