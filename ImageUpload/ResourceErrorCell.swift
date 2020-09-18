//
//  ResourceErrorCell.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class ResourceErrorCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var imageView: CLDUIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var errorDescription: UILabel!
}
