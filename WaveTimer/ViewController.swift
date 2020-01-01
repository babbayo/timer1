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
    var timeInterval = 0.2
    var timeTotal = 180.0
    var timeRemain = 180.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: 0,
                           width: self.view.bounds.size.width,
                           height: self.view.bounds.size.height)
        let waveView = WaveView(frame: frame)
        let timerView = TimerView(frame: frame)
        self.view.addSubview(waveView)
        self.view.addSubview(timerView)
        waveView.startAnimation()
        self.waveView = waveView
        self.timerView = timerView
        updateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.startAndPause(_:)), name: TimerFirstButtonClickNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reset(_:)), name: TimerSecondButtonClickNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.edit(_:)), name: TimerThirdButtonClickNotification, object: nil)
    }
}

// MARL - timer
extension ViewController {
    
    @objc func startAndPause(_ noti: Notification) {
        isStart = !isStart
        if isStart {
            createTimer()
        }
        if let view = self.timerView {
            let text = isStart ? "멈춤" : "시작"
            view.setFirstButtonText(text)
        }
    }
    
    @objc func reset(_ noti: Notification) {
        print("reset")
        if let t = timer {
            t.invalidate()
            timer = nil
        }
        if timeRemain != timeTotal {
            timeRemain = timeTotal
            updateView()
        }
        if isStart == true {
            isStart = false
            if let view = self.timerView {
                view.setFirstButtonText("시작")
            }
        }
    }
    
    @objc func edit(_ noti: Notification) {
        reset(noti)
        print("edit")
        if let editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController"){
            editViewController.modalTransitionStyle = .coverVertical
            self.present(editViewController, animated: true, completion: nil)
        }
    }
    
    func createTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    @objc func updateTimer() {
        if isStart {
            timeRemain = max(timeRemain - timeInterval, 0)
            updateView()
        }
    }
    
    func updateView(){
        if let view = self.waveView {
            let percent = (Float(timeRemain)) / Float(timeTotal)
            view.setProgress(percent)
        }
        if let view = self.timerView {
            view.setText(Int(floor(timeRemain)))
        }
    }
}
