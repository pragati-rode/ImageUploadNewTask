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
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
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
//            if (self.isVideo) {
//                self.effects = CloudinaryHelper1.generateVideoEffectList(cloudinary: self.cloudinary, resource: self.resource)
//            } else {
//                self.effects = CloudinaryHelper1.generateEffectList(cloudinary: self.cloudinary, resource: self.resource)
//            }

            DispatchQueue.main.async {
                self.loadImage()
               // self.updateCurrEffect((self.effects.first)!)
              //  self.activityIndicator.stopAnimating()
            }
        }

        // Do any additional setup after loading the view.
    }
    
    func loadImage() {
        self.imageView.image = nil
                

                  if (isVideo) {
                     
                  } else {
                     
                      self.imageView.isHidden = false

                    //  activityIndicator.isHidden = false
                   //   activityIndicator.startAnimating()
        
                   let params = CLDResponsiveParams.fit().setReloadOnSizeChange(true)
                   self.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary, resourceType: resourceType,
                           responsiveParams: params, transformation: CLDTransformation().setFetchFormat("jpg"))
                   
                  }
    }
    
    fileprivate func updateCurrEffect(_ effect: EffectMetadata) {
         
           self.imageView.image = nil
         

           if (isVideo) {
              
           } else {
              
               self.imageView.isHidden = false

             //  activityIndicator.isHidden = false
            //   activityIndicator.startAnimating()
 
            let params = CLDResponsiveParams.fit().setReloadOnSizeChange(true)
            self.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary, resourceType: resourceType,
                    responsiveParams: params, transformation: CLDTransformation().setFetchFormat("jpg"))
            
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
