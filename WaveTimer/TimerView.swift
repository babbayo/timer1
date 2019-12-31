//
//  TimerView.swift
//  WaveTimer
//
//  Created by MacBook on 29/12/2019.
//  Copyright © 2019 yaco. All rights reserved.
//

import UIKit

let TimerFirstButtonClickNotification: Notification.Name = Notification.Name("TimerFirstButtonClick")
let TimerSecondButtonClickNotification: Notification.Name = Notification.Name("TimerSecondButtonClick")
let TimerThirdButtonClickNotification: Notification.Name = Notification.Name("TimerThirdButtonClick")

class TimerView: UIView {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    private let xibName = "TimerView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func setText(_ remainSeconds: Int) {
        let (h, m, s) = secondsToHoursMinutesSeconds(remainSeconds)
        let text = "\(h)시 \(m)분 \(s)초"
        textLabel.text = text
    }
    
    func setFirstButtonText(_ text: String) {
        firstButton.setTitle(text, for: .normal)
    }
    
    func secondsToHoursMinutesSeconds (_ seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    @IBAction func touchUpFirstButton(_ sender: Any) {
        NotificationCenter.default.post(name: TimerFirstButtonClickNotification, object: nil, userInfo: nil)
    }
    
    @IBAction func touchUpSecondButton(_ sender: Any) {
        NotificationCenter.default.post(name: TimerSecondButtonClickNotification, object: nil, userInfo: nil)
    }
    
    @IBAction func touchUpThirdButton(_ sender: Any) {
        NotificationCenter.default.post(name: TimerThirdButtonClickNotification, object: nil, userInfo: nil)
        
    }
}
