//
//  EffectCell.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class EffectCell: UICollectionViewCell {
    @IBOutlet weak var imageView: CLDUIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var SelectionIndicator: UIView!
}
