//
//  ImageUploadTests.swift
//  ImageUploadTests
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import XCTest
import Cloudinary
@testable import ImageUpload

class ImageUploadTests: XCTestCase {
    
    let prefix = "https://res.cloudinary.com/dfdoypo9b"
var sut: CLDCloudinary?
    override func setUp() {
        super.setUp()
        let config = CLDConfiguration(cloudinaryUrl: "cloudinary://999363646968972:y42rD4ZM4CVMWXb14QhuEZacRGI@dfdoypo9b")!
        sut = CLDCloudinary(configuration: config)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        sut = nil
    }

    func testParseCloudinaryUrlNoPrivateCdn() {
           let config = CLDConfiguration(cloudinaryUrl: "cloudinary://999363646968972:y42rD4ZM4CVMWXb14QhuEZacRGI@dfdoypo9b")

           XCTAssertEqual(config?.apiKey, "999363646968972")
           XCTAssertEqual(config?.apiSecret, "y42rD4ZM4CVMWXb14QhuEZacRGI")
           XCTAssertEqual(config?.cloudName, "dfdoypo9b")
           XCTAssertEqual(config?.privateCdn, false)
       }
    
    func testCloudName() {
         let url = sut?.createUrl().generate("test")
         XCTAssertEqual(url, "\(prefix)/image/upload/test")
     }
     
   


}
