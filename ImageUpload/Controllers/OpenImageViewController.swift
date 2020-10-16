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
    @IBOutlet weak var imgView : UIImageView!
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
            DispatchQueue.main.async {
             //   self.loadImage()
                self.downloadImagefrmCloud()
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
        //https://res.cloudinary.com/dfdoypo9b/image/upload/v1601282666/afrvv5h8mkkqrqawjvdt.jpg
                    //https://res.cloudinary.com/dfdoypo9b/image/upload/v1601278669/tl9q3popioo1btuedyjr.jpg
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
    
    func downloadImagefrmCloud(){
        let progressHandler = { (progress: Progress) in
            print("Downloading from Cloudinary: \(Int(progress.fractionCompleted * 100))%")
        }
       // let url1 =  "https://res.cloudinary.com/dfdoypo9b/image/upload/v1601278669/tl9q3popioo1btuedyjr.jpg"
        let urlString2  = CloudinaryHelper1.getUrlForTransformation(cloudinary, CLDTransformation(), resource)
      //  print(url1)
        let url = URL(string: urlString2)
        
        self.cloudinary.createDownloader().fetchImage(urlString2, progressHandler, completionHandler: { (result,error) in
            
            if let error = error {
                print("Error downloading image %@", error)
            }
            else {
                print("Image downloaded from Cloudinary successfully")
                
                do{
                    let data = try Data(contentsOf: url!)
                    DispatchQueue.main.async {
                    self.imgView.image = UIImage(data: data)
                   // self.imgView.image = UIImage(data: data)
                  //  self.savePhotos()
                    }
                    
                }
                catch let er as NSError{
                    print(er)
                }
                
            }
        
        })
    }

}
