//
//  ViewController.swift
//  WaveTimer
//
//  Created by MacBook on 28/12/2019.
//  Copyright © 2019 yaco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer?
    var waveView: WaveView?
    var timerView: TimerView?
    var isStart = false
    var seconds: Int?
    var nowSeconds: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 0,
                           width: self.view.bounds.size.width,
                           height: self.view.bounds.size.height)
//        let firstColor = UIColor.init(red: 252/255, green: 158/255, blue: 50/255, alpha: 1)
//        let secondColor = UIColor.init(red: 167/255, green: 192/255, blue: 229/255, alpha: 0.5)
//        let thirdColor = UIColor.init(red: 173/255, green: 178/255, blue: 255/255, alpha: 0.5)
        
        let waveView = WaveView(frame: frame)
        let timerView = TimerView(frame: frame)
        self.view.addSubview(waveView)
        self.view.addSubview(timerView)
        waveView.startAnimation()
        
        self.waveView = waveView
        self.timerView = timerView
    }
}

// MARL - timer
extension ViewController {
    
    func edit() {
        
    }
    
    func start() {
        isStart = true
        createTimer()
        
    }
    
    func pause() {
        isStart = false
        
    }
    
    func reset() {
        if let t = timer {
            t.invalidate()
            timer = nil
        }
    }
    
    func createTimer() {
        // 1
        if timer == nil {
            // 2
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    @objc func updateTimer() {
        if isStart {
            
        }
    }
}
