//
//  WaveView3.swift
//  WaveTimer
//
//  Created by MacBook on 29/12/2019.
//  Copyright © 2019 yaco. All rights reserved.
//

import UIKit

class WaveView: UIView {
    
    private let firstWaveLine: UIBezierPath = UIBezierPath()
    private let secondWaveLine: UIBezierPath = UIBezierPath()
    private let thirdWaveLine: UIBezierPath = UIBezierPath()
    
    private let firstWaveLayer: CAShapeLayer = CAShapeLayer()
    private let seondWaveSubLayer: CAShapeLayer = CAShapeLayer()
    private let thirdWaveSubLayer: CAShapeLayer = CAShapeLayer()
    
    private var firstWaveGradientLayer: CAGradientLayer = CAGradientLayer()
    
    private var timer = Timer()
    
    private var drawSeconds: CGFloat = 0.0
    private var drawElapsedTime: CGFloat = 0.0
    
    private var width: CGFloat
    private var height: CGFloat
    private var xAxis: CGFloat
    private var yAxis: CGFloat
    
    //0.0 .. 1.0 are avaliable, default is 0.5
    open var progress: Float {
        willSet {
            self.xAxis = self.height - self.height*CGFloat(min(max(newValue, 0),1))
        }
    }
    
    open var waveHeight: CGFloat = 15.0 //3.0 .. about 50.0 are standard.
    open var waveDelay: CGFloat = 300.0 //0.0 .. about 500.0 are standard.
    
    open var firstColor: UIColor!
    open var secondColor: UIColor!
    open var thirdColor: UIColor!
    
    private override init(frame: CGRect) {
        self.width = frame.width
        self.height = frame.height
        self.xAxis = floor(height/2)
        self.yAxis = 0.0
        self.progress = 0.5
        super.init(frame: frame)
    }
    
    //Possible to set fillColors separately.
    public convenience init(frame: CGRect, firstColor: UIColor, secondColor: UIColor, thirdColor: UIColor) {
        self.init(frame: frame)
        
        let firstColor = UIColor.init(red: 252/255, green: 158/255, blue: 50/255, alpha: 1)
        let secondColor = UIColor.init(red: 167/255, green: 192/255, blue: 229/255, alpha: 0.5)
        let thirdColor = UIColor.init(red: 173/255, green: 178/255, blue: 255/255, alpha: 0.5)
        
        self.firstColor = firstColor
        self.secondColor = secondColor
        self.thirdColor = thirdColor
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        
        wave(layer: thirdWaveSubLayer,
             gradientLayer: nil,
             path: thirdWaveLine, color: thirdColor, delay: waveDelay * 2)
        wave(layer: seondWaveSubLayer,
             gradientLayer: nil,
            path: secondWaveLine, color: secondColor, delay: waveDelay)
        wave(layer: firstWaveLayer,
             gradientLayer: firstWaveGradientLayer,
             path: firstWaveLine, color: firstColor, delay: 0)
    }
    
    //0.0 .. 1.0 are avaliable
    open func setProgress(_ point: Float) {
        let setPoint:CGFloat = CGFloat(min(max(point, 0),1))
        
        self.progress = Float(setPoint)
    }
    
    
    //Start wave Animation
    open func startAnimation() {
        timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(waveAnimation), userInfo: nil, repeats: true)
    }
    
    //MARK: Please be sure to call this method at ViewDidDisAppear or deinit in ViewController.
    //If it isn't called, Memory Leaks occurs by Timer
    open func stopAnimation() {
        timer.invalidate()
    }
    
    @objc private func waveAnimation() {
        self.setNeedsDisplay()
    }
    
    
    @objc private func wave(layer: CAShapeLayer, gradientLayer: CAGradientLayer?, path: UIBezierPath, color: UIColor, delay:CGFloat) {
        path.removeAllPoints()
        drawWave(layer: layer, gradientLayer: gradientLayer,
                 path: path, color: color, delay: delay)
        drawSeconds += 0.009
        drawElapsedTime = drawSeconds*CGFloat(Double.pi)
        if drawElapsedTime >= CGFloat(Double.pi) {
            drawSeconds = 0.0
            drawElapsedTime = 0.0
        }
    }
    
    private func drawWave(layer: CAShapeLayer, gradientLayer: CAGradientLayer?, path: UIBezierPath,color: UIColor,delay:CGFloat) {
        drawSin(path: path,time: drawElapsedTime/0.5, delay: delay)
        path.addLine(to: CGPoint(x: width+10, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()
        
        layer.fillColor = color.cgColor
        layer.path = path.cgPath
        
        if let gradient = gradientLayer {
            gradient.frame = frame
            gradient.colors = [UIColor(red:169/255, green:245/255, blue:252/255, alpha:0.7).cgColor,
                               UIColor(red:134/255, green:196/255, blue:232/255, alpha:0.7).cgColor,
                               UIColor(red:91/255, green:93/255, blue:161/255, alpha:1).cgColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
            gradient.mask = layer
            self.layer.addSublayer(gradient)
        } else {
            self.layer.addSublayer(layer)
        }
    }
    
    private func drawSin(path: UIBezierPath, time: CGFloat, delay: CGFloat) {
        
//        let unit:CGFloat = 300.0
        let unit:CGFloat = 100.0
        let zoom:CGFloat = 1.0
//        let zoom:CGFloat = 0.7
        var x = time
        var y = sin(x + delay)/zoom
        let start = CGPoint(x: yAxis, y: unit*y+xAxis)
        
        path.move(to: start)
        
        var i = yAxis
        while i <= width+10 {
            x = time+(-yAxis+i)/unit/zoom
            y = sin(x - delay)/self.waveHeight
            path.addLine(to: CGPoint(x: i, y: unit*y+xAxis))
            i += 10
        }
    }
    
}
