//
//  CheckMarkView.swift
//  CheckMark
//
//  Created by Shripada Hebbar on 29/05/16.
//  Copyright © 2016 Shripada Hebbar. All rights reserved.
//

import UIKit


class CheckMarkView: UIView {
    
    var outerCircle : CAShapeLayer!
    var mask : CAShapeLayer!
    var innerCircle: CAShapeLayer!
    var tickMark : CAShapeLayer!
    
    var boundaryColor = UIColor.redColor().CGColor
    var fillColor = UIColor.redColor().CGColor
    var tickMarkColor = UIColor.whiteColor().CGColor
    var boundaryThickNess = 2.0
    var tickMarkWidth : CGFloat = 4.0
    
    var tapGesture :UITapGestureRecognizer?
    
    var gestureEnabled : Bool = true //Set this to false if you dont want tap gesture to initiate an animation of Check Mark 
    
    func tapped(gesture:UITapGestureRecognizer){
        animate()
    }
    
    func setUp(){
        
        if gestureEnabled {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            self.addGestureRecognizer(tapGesture!)
        }else{
            if let tapGesture = tapGesture{
                self.removeGestureRecognizer(tapGesture)
                self.tapGesture = nil
            }
        }
        
        outerCircle = outerCircleLayer()
        layer.addSublayer(outerCircle)
        innerCircle = innerLayer()
        layer.addSublayer(innerCircle)
    }
    
    //MARK: Public interface
    func animate(){
        
        if(outerCircle == nil ){
            setUp()
        }else{
            outerCircle.removeFromSuperlayer()
            innerCircle.removeFromSuperlayer()
            tickMark.removeFromSuperlayer()
            setUp()
        }
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.setValue("Stroke", forKey: "name")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.repeatCount = 0
        anim.duration = 0.5
        anim.delegate = self
        
        outerCircle.addAnimation(anim, forKey: "StrokEnd")
        outerCircle.strokeEnd = 1.0
        
    }
    
    //MARK: Animation helpers
    
    func animateMask(){
        
        //from values
        let fromOuterPath = UIBezierPath(ovalInRect: bounds)
        let fromInnerPath = UIBezierPath(ovalInRect: bounds)
        
        fromOuterPath.appendPath(fromInnerPath)
        fromOuterPath.usesEvenOddFillRule = true
        
        //to values
        let outerPath = UIBezierPath(ovalInRect:bounds)
        var targetRect = CGRectZero
        
        targetRect.origin.x = self.bounds.width/2
        targetRect.origin.y = self.bounds.height/2
        
        let innerPath = UIBezierPath(ovalInRect:targetRect)
        
        outerPath.appendPath(innerPath)
        outerPath.usesEvenOddFillRule = true
       
        mask.fillRule = kCAFillRuleEvenOdd
        
        //Path animation
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = fromOuterPath.CGPath
        anim.toValue = outerPath.CGPath
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.fillMode = kCAFillModeBoth //We want to persist the effect after the animation
        anim.removedOnCompletion = false
        anim.setValue("mask", forKey: "name")
        anim.delegate = self
        mask.addAnimation(anim, forKey: anim.keyPath)
    }
    
    func animateTick() {
        
        tickMark = tickMarkLayer()
        layer.addSublayer(tickMark)
        
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.setValue("Tick", forKey: "name")
        anim.fromValue = 0.0
        anim.toValue = 1.0
        anim.repeatCount = 0
        anim.duration = 0.3
        anim.delegate = self
        
        tickMark.addAnimation(anim, forKey: "StrokEnd")
        tickMark.strokeEnd = 1.0
    }
    
    func animateScale(){
        
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: .CalculationModePaced, animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.2, animations: {
                self.transform = CGAffineTransformMakeScale(1.1, 1.1)
            })
            
            UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.3, animations: {
                self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            })
            
            }, completion: nil )
        
        
    }
    
    //MARK: Layer creations
    
    func innerLayer() -> CAShapeLayer{
        let innerCircle = CAShapeLayer()
        var innerFrame = bounds
        innerFrame.origin.x = 0
        innerFrame.origin.y = 0
        innerCircle.path = UIBezierPath(ovalInRect: innerFrame).CGPath
        
        innerCircle.frame = bounds
        innerCircle.fillColor = fillColor
        
        //Also set mask
        
        mask = maskLayer()
        mask.frame = innerCircle.bounds
        innerCircle.mask = mask
        
        
        return innerCircle
    }
    
    func outerCircleLayer()-> CAShapeLayer{
        let outerCircle = CAShapeLayer()
        outerCircle.path = UIBezierPath(ovalInRect: self.bounds).CGPath
        outerCircle.strokeColor = boundaryColor
        var frame = self.frame
        frame.origin.x = 0
        frame.origin.y = 0
        outerCircle.strokeStart = 0.0
        outerCircle.strokeEnd = 0.0
        outerCircle.frame = frame
        outerCircle.lineWidth = 2.0
        outerCircle.fillColor = UIColor.clearColor().CGColor
        
        outerCircle.backgroundColor = UIColor.clearColor().CGColor
        
        
        
        return outerCircle
    }
    
    func maskLayer() -> CAShapeLayer{
        
        let mask = CAShapeLayer()
        let outerPath = UIBezierPath(ovalInRect:CGRectZero)
        mask.path = outerPath.CGPath
        
        return mask
        
    }
    
    func tickMarkLayer() ->CAShapeLayer
    {
        let tickMark = CAShapeLayer()
        tickMark.frame = bounds
        let centerX = self.bounds.width/2
        let centerY = self.bounds.height/2
        
        var start = CGPointZero
        start.x = centerX - self.bounds.width/2.5
        start.y = centerY
        
        var down = CGPointZero
        
        down.x = centerX  - self.bounds.width/5
        down.y = centerY + self.bounds.height/4
        
        
        var end = CGPointZero
        
        end.x = centerX +  self.bounds.width/3
        end.y = centerY -  self.bounds.height/3.5
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(down)
        path.addLineToPoint(end)
        
        tickMark.path = path.CGPath
        
        tickMark.strokeStart = 0.0
        tickMark.strokeEnd = 0.0
        tickMark.lineWidth = tickMarkWidth
        tickMark.strokeColor = tickMarkColor
        tickMark.fillColor = UIColor.clearColor().CGColor
        tickMark.lineCap = kCALineCapSquare
        
        return tickMark
        
    }
    
}

//MARK: Animation Delegate 
//We just use this to sequence our animations
extension CheckMarkView {
    override func animationDidStop(anim: CAAnimation, finished flag: Bool){
        
        if let animName = anim.valueForKey("name") as? String{
            switch animName {
            case "Stroke" :
                animateMask()
            case "mask":
                animateTick()
            case "Tick":
                animateScale()
            default :
                break
            }
        }
        
    }
    
    
}



