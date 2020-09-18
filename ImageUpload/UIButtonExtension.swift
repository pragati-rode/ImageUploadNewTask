//
//  UIButtonExtension.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UIButtonExtension: UIButton {

   func createFloatingActionButton11() {
        backgroundColor = UIColor.black
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
