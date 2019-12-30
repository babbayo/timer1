//
//  TimerView.swift
//  WaveTimer
//
//  Created by MacBook on 29/12/2019.
//  Copyright © 2019 yaco. All rights reserved.
//

import UIKit

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

    @IBAction func touchUpFirstButton(_ sender: Any) {
    }
    
    @IBAction func touchUpSecondButton(_ sender: Any) {
    }
    
    @IBAction func touchUpThirdButton(_ sender: Any) {
    }
}
