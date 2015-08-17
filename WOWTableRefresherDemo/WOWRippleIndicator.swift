//
//  WOWRippleIndicator.swift
//  WOWTableRefresherDemo
//
//  Created by Zhou Hao on 17/8/15.
//  Copyright © 2015 Zhou Hao. All rights reserved.
//

import UIKit

public class WOWRippleIndicator: UIView {

    var ripples = [CAShapeLayer]()
    var ring : CAShapeLayer!
    
    override public var bounds : CGRect {
        didSet {

            let bounds = getNewBounds()
            layer.masksToBounds = true
            layer.bounds = bounds
            layer.cornerRadius = bounds.width/2
            
            ring.frame = layer.bounds
            ring.fillColor = UIColor.clearColor().CGColor
            ring.strokeColor = UIColor.orangeColor().CGColor
            ring.lineWidth = 5
            
            let radius = layer.bounds.width / 2
            let center = CGPointMake(radius, radius)
            ring.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true).CGPath
            ring.strokeEnd = 0
        }
    }
    
    public var degree : CGFloat = 0 {
        
        didSet {
            
            print("degree = \(degree)")
            ring.strokeEnd = degree
            
//            let animateStrokeDown = CABasicAnimation(keyPath: "strokeEnd")
//            animateStrokeDown.fromValue = oldValue
//            animateStrokeDown.toValue = degree
//            circle.addAnimation(animateStrokeDown, forKey: "stroke")
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRectZero)
        setup()
    }
    
    init() {
        super.init(frame: CGRectZero)
        setup()
    }
    
    public func startAnimation() {
        
        setupRipples()
        
        var delay : Double = 0
        for circle in ripples {
            
            GCD.delay(delay, block: { () -> () in
                let animScale = CABasicAnimation(keyPath: "transform.scale")
                animScale.fromValue = 0
                animScale.toValue = 1
                
                circle.transform = CATransform3DMakeScale(1.0,1.0,1.0)
                circle.addAnimation(animScale, forKey: "scale")
                
                let animAlpha = CABasicAnimation(keyPath: "opacity")
                animAlpha.fromValue = 1
                animAlpha.toValue = 0
                animAlpha.removedOnCompletion = false
                animAlpha.fillMode = kCAFillModeForwards
                
                circle.addAnimation(animAlpha, forKey: "alpha")
                
                let animGroup = CAAnimationGroup()
                animGroup.animations = [animScale,animAlpha]
                animGroup.repeatCount = Float.infinity
                animGroup.duration = 0.8
                circle.addAnimation(animGroup, forKey: "")
            })
            
            delay += 0.2
        }
        
    }
    
    public func stopAnimation() {
        
        for circle in ripples {
            circle.removeAllAnimations()
        }
    }
    
    private func setup() {
        
        ring = CAShapeLayer()
        layer.addSublayer(ring)
        
    }

    private func setupRipples() {
    
        ripples = [CAShapeLayer]()
        ripple()
        ripple()
        ripple()
    }
    
    private func ripple() {
        
        let circle = CAShapeLayer()
        
        // anchorPoint doesn't work
        // need to set the layer's frame
        let radius = layer.bounds.width / 2
        let center = CGPointMake(radius, radius)
        circle.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: false).CGPath
        
        circle.frame = layer.bounds
        
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor.orangeColor().CGColor
        circle.lineWidth = 2
        
        self.layer.addSublayer(circle)
        
        ripples.append(circle)
    }
    
    private func pathFor(layer : CALayer, radius : CGFloat) -> CGPathRef {
        
        let center = CGPointMake(layer.bounds.width / 2, layer.bounds.width / 2)
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: false).CGPath
    }
    
    private func getNewBounds() -> CGRect {
        
        var newBounds : CGRect
        if layer.bounds.width > layer.bounds.height {
            newBounds = CGRectMake(0, 0, layer.bounds.height, layer.bounds.height)
        } else {
            newBounds = CGRectMake(0, 0, layer.bounds.width, layer.bounds.width)
        }
        return newBounds
        
    }
    
}
