//
//  ResourceCell.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class ResourceCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var imageView: CLDUIImageView!
    
//    override var isSelected: Bool{
//           didSet{
//               UIView.animate(withDuration: 2.0) {
//                self.imageView.transform = self.isSelected ? CGAffineTransform(scaleX: 15.0, y: 15.0) : CGAffineTransform.identity
//               }
//           }
//       }
    
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//    imageView.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
//    layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//    return layoutAttributes
}

