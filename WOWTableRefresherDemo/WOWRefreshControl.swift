//
//  WOWRefreshControl.swift
//  WOWTableRefresherDemo
//
//  Created by Zhou Hao on 17/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

public class WOWRefreshControl: UIRefreshControl,UIScrollViewDelegate {
    
    let kIndicatorWidth : CGFloat = 40.0
    enum ScrollDirection {
        case vertical
        case horizontal
    }
    
    public typealias CompletionHandler = () -> Void
    
    public var completionHandler : CompletionHandler?
    public var lineWidth : CGFloat = 2.0
    public var lineColor : UIColor = UIColor.blackColor()
    
    private var refreshLoadingView : UIView!
    private var rippleIndicator : WOWRippleIndicator?
    private var direction : ScrollDirection = ScrollDirection.vertical
    private var scrollView : UIScrollView!
    
    override public var backgroundColor : UIColor?  {
        didSet {
            refreshLoadingView.backgroundColor = backgroundColor
        }
    }
    
    // MARK: life circle
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Should call init(scrollView...)")
    }
    
    init(scrollView: UIScrollView, direction:ScrollDirection ,readyToRefresh handler:CompletionHandler?) {
        super.init()
        
        self.direction = direction
        self.scrollView = scrollView
        self.scrollView.delegate = self
        completionHandler = handler
        
        setup()
    }
    
    // MARK: methods
    func setup() {
        
        if direction == .horizontal {
            self.scrollView.alwaysBounceHorizontal = true
            self.scrollView.alwaysBounceVertical = false
        } else {
            self.scrollView.alwaysBounceHorizontal = false
            self.scrollView.alwaysBounceVertical = true
        }
        print("\(scrollView.frame)")
        addTarget(self, action: "onReadyToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        scrollView.addSubview(self)
//        scrollView.bringSubviewToFront(self)
        
        // hide the original spinner
        self.tintColor = UIColor.clearColor()
        
        // size not decided yet
        // loading view to cover the default view
        refreshLoadingView = UIView()
        addSubview(refreshLoadingView)
//        self.bringSubviewToFront(refreshLoadingView)
//        self.scrollView.bringSubviewToFront(self)
        
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
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if direction == .vertical {
            let pullDistance = max(0.0, -self.frame.origin.y);
            var refreshBounds = self.bounds
            
            // Set the encompassing view's frames
            refreshBounds.size.height = pullDistance;
            refreshLoadingView.frame = refreshBounds;
        
            print(refreshLoadingView.frame)
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
        } else {
            
            // TODO: this doesn't work because there is no horizontal UIRefreshControl supported
            let offset = scrollView.contentOffset
            let inset = scrollView.contentInset
            let pullDistance: CGFloat = max(0,-(offset.x - inset.left))
            
            var refreshBounds = self.bounds
            
            refreshBounds.size.width = pullDistance
            refreshBounds.origin.y = scrollView.contentInset.top
            
            refreshLoadingView.frame = refreshBounds;
            
            scrollView.bringSubviewToFront(self)
            self.bringSubviewToFront(refreshLoadingView)
            
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
            }
        }
        
    }
    
    public func stopRefresh() {
        self.endRefreshing()
        if rippleIndicator != nil {
            rippleIndicator!.stopAnimation()
        }
    }
    
}
