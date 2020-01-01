//
//  EditView.swift
//  WaveTimer
//
//  Created by MacBook on 31/12/2019.
//  Copyright © 2019 yaco. All rights reserved.
//

import UIKit

let EditSaveButtonClickNotification: Notification.Name = Notification.Name("EditSaveButtonClick")

class EditView: UIView {
    private let xibName = "EditView"

    override init(frame: CGRect) {
        super.init(frame: frame)
         self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit(){
        guard let view = Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)?.first as? UIView else {    // 3
            print("no bundle")
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        NotificationCenter.default.post(name: EditSaveButtonClickNotification, object: nil, userInfo: nil)
    }
}
