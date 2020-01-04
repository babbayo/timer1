//
//  TimeControl.swift
//  WaveTimer
//
//  Created by MacBook on 04/01/2020.
//  Copyright © 2020 yaco. All rights reserved.
//

import UIKit

class TimeControl: UIControl {
    
    var minimumValue: Float = 0
    var maximumValue: Float = 8
    private (set) var value: Float = 0
    
    func setValue(_ newValue: Float, animated: Bool = false) {
        value = min(maximumValue, max(minimumValue, newValue))
        if animated {
            value = round(value)
        }
        
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
        renderer.setPointerAngle(angleValue, animated: animated)
    }
    
    var isContinuous = true
    
    private let renderer = TimeControlRenderer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        renderer.updateBounds(bounds)
        renderer.color = tintColor
        renderer.setPointerAngle(renderer.startAngle, animated: false)
        
        layer.addSublayer(renderer.trackLayer)
        layer.addSublayer(renderer.pointerLayer)
        
        let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(TimeControl.handleGesture(_:)))
        
        addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
        // 1
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
        // 2
        var boundedAngle = gesture.touchAngle
        if boundedAngle > midPointAngle {
            boundedAngle -= 2 * CGFloat(Double.pi)
        } else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
            boundedAngle -= 2 * CGFloat(Double.pi)
        }
        
        // 3
        boundedAngle = min(endAngle, max(startAngle, boundedAngle))
        
        // 4
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        
        // 5
        setValue(angleValue, animated: gesture.needAnimation)
        
        // 6
        if isContinuous {
            sendActions(for: .valueChanged)
        } else {
            if gesture.state == .ended || gesture.state == .cancelled {
                sendActions(for: .valueChanged)
            }
        }
    }
    
    
    var lineWidth: CGFloat {
        get { return renderer.lineWidth }
        set { renderer.lineWidth = newValue }
    }
    
    var startAngle: CGFloat {
        get { return renderer.startAngle }
        set { renderer.startAngle = newValue }
    }
    
    var endAngle: CGFloat {
        get { return renderer.endAngle }
        set { renderer.endAngle = newValue }
    }
    
    var pointerLength: CGFloat {
        get { return renderer.pointerLength }
        set { renderer.pointerLength = newValue }
    }
    
    private class TimeControlRenderer {
        var color: UIColor = .blue {
            didSet {
                trackLayer.strokeColor = color.cgColor
                pointerLayer.strokeColor = color.cgColor
            }
        }
        
        var lineWidth: CGFloat = 2 {
            didSet {
                trackLayer.lineWidth = lineWidth
                pointerLayer.lineWidth = lineWidth
                updateTrackLayerPath()
                updatePointerLayerPath()
            }
        }
        
        var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
            didSet {
                updateTrackLayerPath()
            }
        }
        
        var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
            didSet {
                updateTrackLayerPath()
            }
        }
        
        var pointerLength: CGFloat = 6 {
            didSet {
                updateTrackLayerPath()
                updatePointerLayerPath()
            }
        }
        
        private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
        
        func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
            //            print(newPointerAngle)
            if animated {
                let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2
                    + min(newPointerAngle, pointerAngle)
                
                let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                animation.values = [pointerAngle, midAngleValue, newPointerAngle]
                animation.keyTimes = [0.0, 0.5, 1.0]
                animation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
                
                let moreMidAngleValue = (max(newPointerAngle, midAngleValue) - min(newPointerAngle, midAngleValue)) / 2
                    + min(newPointerAngle, midAngleValue)
                
                let animation2 = CAKeyframeAnimation(keyPath: "transform.rotation.z")
                animation2.duration = 0.05
                animation2.repeatCount = 8
                animation2.autoreverses = true
                animation2.values = [newPointerAngle, moreMidAngleValue, midAngleValue]
                animation2.keyTimes = [0.0, 0.5, 1.0]
                
                pointerLayer.add(animation, forKey: "transformZ")
                pointerLayer.add(animation2, forKey: "shaking")
            }
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)
            
            
            CATransaction.commit()
            pointerAngle = newPointerAngle
        }
        
        let trackLayer = CAShapeLayer()
        let pointerLayer = CAShapeLayer()
        
        init() {
            trackLayer.fillColor = UIColor.clear.cgColor
            pointerLayer.fillColor = UIColor.clear.cgColor
        }
        
        private func updateTrackLayerPath() {
            let bounds = trackLayer.bounds
            let center = CGPoint(x: bounds.midX, y: bounds.midY)
            let offset = max(pointerLength, lineWidth  / 2)
            let radius = min(bounds.width, bounds.height) / 2 - offset
            
            let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle,
                                    endAngle: endAngle, clockwise: true)
            trackLayer.path = ring.cgPath
        }
        
        private func updatePointerLayerPath() {
            let bounds = trackLayer.bounds
            
            let pointer = UIBezierPath()
            pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength)
                - CGFloat(lineWidth) / 2, y: bounds.midY))
            pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
            pointerLayer.path = pointer.cgPath
        }
        
        func updateBounds(_ bounds: CGRect) {
            trackLayer.bounds = bounds
            trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
            updateTrackLayerPath()
            
            pointerLayer.bounds = trackLayer.bounds
            pointerLayer.position = trackLayer.position
            updatePointerLayerPath()
        }
        
    }
    
    private class RotationGestureRecognizer: UIPanGestureRecognizer {
        private(set) var touchAngle: CGFloat = 0
        private(set) var needAnimation: Bool = false;
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesBegan(touches, with: event)
            needAnimation = false
            updateAngle(with: touches)
        }
        
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesMoved(touches, with: event)
            needAnimation = false
            updateAngle(with: touches)
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            super.touchesEnded(touches, with: event)
            needAnimation = true
            updateAngle(with: touches, true)
        }
        
        override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
            maximumNumberOfTouches = 1
            minimumNumberOfTouches = 1
        }
        
        private func updateAngle(with touches: Set<UITouch>, _ isEnd: Bool = false) {
            guard
                let touch = touches.first,
                let view = view
                else {
                    return
            }
            let touchPoint = touch.location(in: view)
            touchAngle = angle(for: touchPoint, in: view)
        }
        
        private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
            let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
            return atan2(centerOffset.y, centerOffset.x)
        }
    }
}
