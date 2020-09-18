//
//  OpenImageViewController.swift
//  ImageUpload
//
//  Created by Admin on 9/17/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
import Cloudinary




class OpenImageViewController: UIViewController,UploadedResourceDetails {
    
    @IBOutlet weak var imageView: CLDUIImageView!
    @IBOutlet weak var closeButton: UIButton!
    var currEffect: EffectMetadata?
    var currUrl: String?
    var effects = [EffectMetadata]()
    var resource: CloudResource!
    var cloudinary: CLDCloudinary!
    var observation: NSKeyValueObservation?
    var isVideo: Bool!
    var resourceType: CLDUrlResourceType!
    
    
    
    func setResource(resource: CloudResource) {
        self.resource = resource
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        cloudinary = appDelegate.cloudinary
        self.isVideo = resource.resourceType == "video"
        self.resourceType = isVideo ? CLDUrlResourceType.video : CLDUrlResourceType.image

        DispatchQueue.global().async {
            if (self.isVideo) {
                self.effects = CloudinaryHelper1.generateVideoEffectList(cloudinary: self.cloudinary, resource: self.resource)
            } else {
                self.effects = CloudinaryHelper1.generateEffectList(cloudinary: self.cloudinary, resource: self.resource)
            }

            DispatchQueue.main.async {
               
                self.updateCurrEffect((self.effects.first)!)
            }
        }

        // Do any additional setup after loading the view.
    }
    
    fileprivate func updateCurrEffect(_ effect: EffectMetadata) {
           currEffect = effect
          // descriptionLabel.text = effect.description
           self.imageView.image = nil
          // self.player.replaceCurrentItem(with: nil)

           // Apply scaling/responsive params to a copy of the transformation:
           let transformation = effect.transformation.copy() as! CLDTransformation

           if (isVideo) {
               // manually set size (for images goth are automatic, see the else clause below). Note that DPR
               // is not supported for videos so we fetch with pixel size:
               transformation.chain().setWidth(Int(round(UIScreen.main.bounds.width * UIScreen.main.scale)))
               self.currUrl = cloudinary.createUrl()
                       .setResourceType(self.resourceType)
                       .setTransformation(transformation)
                       .setFormat("mp4")
                       .generate(resource.publicId!)

              // self.videoView.isHidden = false
              // self.avpController.view.isHidden = false
               self.imageView.isHidden = true
            //   activityIndicator.isHidden = true
             //  let url = URL(string: self.currUrl!)!
              // self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
           } else {
               transformation.setFetchFormat("png")
               // note: This url will be used when openning the browser, this is NOT identical to the one shown
               // inside the app - In the app the size is determined automatically. In the url for browser, the size
               // will be screen width for full-screen view.
               self.currUrl = updateCurrUrlForBrowser(cloudinary, transformation)
              // self.videoView.isHidden = true
              // self.avpController.view.isHidden = true
               self.imageView.isHidden = false

              // activityIndicator.isHidden = false
              // activityIndicator.startAnimating()

               // use CLDUIImageView with CLDResponsiveParams to automatically handle fetch dimensions and dpr:
               let params = CLDResponsiveParams.fit().setReloadOnSizeChange(true)
               self.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary, resourceType: self.resourceType, responsiveParams: params, transformation: transformation)
           }
       }
    
    fileprivate func updateCurrUrlForBrowser(_ cloudinary: CLDCloudinary, _ transformation: CLDTransformation) -> String {
        let copy = transformation.copy() as! CLDTransformation
        copy.chain().setDpr(Float(UIScreen.main.scale)).setWidth(Int(round(UIScreen.main.bounds.width)))
        return cloudinary.createUrl().setTransformation(copy).setResourceType(self.resourceType).generate(resource.publicId!)!
    }
    
    
    @IBAction func closedButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
