//
//  CloudConfig.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import  Cloudinary


internal let prefix = "https://res.cloudinary.com/dfdoypo9b"

 //var sut: CLDCloudinary?

 func setUp() {
    
  //  let config = CLDConfiguration(cloudinaryUrl: "CLOUDINARY_URL=cloudinary://999363646968972:y42rD4ZM4CVMWXb14QhuEZacRGI@dfdoypo9b")!
   // sut = CLDCloudinary(configuration: config)
}
internal enum CollectionViewType : Int {
    case uploaded = 1
    case InProgress = 2
    
}

internal struct SettingCloudConfig {
   // static var sut: CLDCloudinary?
    static let cloudName: String  = "dfdoypo9b"
    static let api_key: String = "999363646968972"
    static let api_secret : String = "y42rD4ZM4CVMWXb14QhuEZacRGI"
    static let cloudinaryUrl: String = "CLOUDINARY_URL=cloudinary://999363646968972:y42rD4ZM4CVMWXb14QhuEZacRGI@dfdoypo9b"
    
    static let config = CLDConfiguration(cloudinaryUrl: "CLOUDINARY_URL=cloudinary://999363646968972:y42rD4ZM4CVMWXb14QhuEZacRGI@dfdoypo9b")
     static let sut = CLDCloudinary(configuration: config!)
}



