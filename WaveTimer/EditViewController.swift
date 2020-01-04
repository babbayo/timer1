//
//  EditViewController.swift
//  WaveTimer
//
//  Created by MacBook on 31/12/2019.
//  Copyright © 2019 yaco. All rights reserved.
//

import UIKit

class EditViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0,
        width: self.view.bounds.size.width,
        height: self.view.bounds.size.height)
        
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        self.view.addSubview(blurEffectView)
        
        let editView = EditView(frame: frame)
        self.view.addSubview(editView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.save(_:)), name: EditSaveButtonClickNotification, object: nil)
    }
    
    @objc func save(_ noti: Notification) {
        self.dismiss(animated: true, completion: nil)
    }
}
