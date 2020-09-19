//
//  UploadedViewController.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Cloudinary
import MobileCoreServices
import Photos

class UploadedViewController: BaseCollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    // MARK: Properties
  //  @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var imageView : CLDUIImageView!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet weak var uploadingStatusLabel : UILabel!
    @IBOutlet weak var viewForUploadingStatus : UIView!
    @IBOutlet weak var viewForUploadedImages : UIView!
   
    @IBOutlet weak var plusButton: UIButton!
    
    var viewType: CollectionViewType = .uploaded
    static let progressChangedNotification1 = NSNotification.Name(rawValue: "com.cloudinary.sample.progress.notification")
    
    var progressMap: [String: Progress] = [:]
    @IBOutlet weak var heightlayoutConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
           super.viewDidLoad()
        
            viewForUploadingStatus.isHidden = true
            heightlayoutConstraint.constant = 0
            viewForUploadedImages.layer.cornerRadius = 10
            viewForUploadingStatus.layer.cornerRadius = 5
        collectionView.layer.cornerRadius = 10
        
            
           NotificationCenter.default.addObserver(self, selector: #selector(UploadedViewController.progressChanged(notification:)), name: UploadedViewController.progressChangedNotification1, object: nil)
        let gestureRec = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        viewForUploadingStatus.addGestureRecognizer(gestureRec)
        
       }


    override func reloadData() {
        PersistenceHelper.fetch(statuses: [PersistenceHelper.UploadStatus.uploaded]) { fetchedResources in
            self.resources = fetchedResources as! [CloudResource]
            if self.resources.count > 0 {
                self.viewForUploadedImages.backgroundColor = self.collectionViewColor
            }
            self.collectionView.reloadData()
        }
    }

    override func getCollectionView() -> UICollectionView! {
        return collectionView
    }
   
   
    override func getPlusButton() -> UIButton! {
        return plusButton
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextScene = segue.destination as? UploadedResourceDetails {
            if let cell = sender as? UICollectionViewCell, let indexPath = self.collectionView.indexPath(for: cell) {
               // nextScene.delegate = self
                nextScene.setResource(resource: self.resources[indexPath.row])
            }
        }
    }
    
    @objc func someAction(_ sender:UITapGestureRecognizer){
        let controller = storyboard?.instantiateViewController(withIdentifier: "InProgressViewController")
        controller?.modalPresentationStyle = .fullScreen
        self.present(controller!, animated: true, completion: nil)
        // swift 2
        // self.presentViewController(controller, animated: true, completion: nil)
    }
    @IBAction func showPicker(_ sender: Any) {
           if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
                     doShowPicker()
                 } else {
                     PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in ()
                         if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
                             self.doShowPicker()
                         }
                     })
                 }
       }
       
       private func doShowPicker(){
           
           DispatchQueue.main.async { [weak self] in
               let imagePickerController = UIImagePickerController()
               imagePickerController.sourceType = .photoLibrary
               imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
               imagePickerController.delegate = self
               self?.present(imagePickerController, animated: true, completion: nil)
           }
       }
    
    @objc func progressChanged(notification: NSNotification) {
        // update progress in map
        let name = notification.userInfo?["name"] as? String
        let progress = notification.userInfo?["progress"] as? Progress

        if (name != nil && progress != nil) {
            progressMap[name!] = progress!
        }
        viewForUploadingStatus.isHidden = false
        heightlayoutConstraint.constant = 70
        // refresh views
       reloadData111()
        if resources.count > 0 {
        let resource = resources[0]
            DispatchQueue.main.async {
                self.setLocalImage(imageView: self.imageView, resource: resource)
            
        
            
        //overlayView.isHidden = true
                if let progress = self.progressMap[resource.localPath!] {
           // overlayView.isHidden = false
                    self.progressView.isHidden = false
                    self.progressView.progress = Float(progress.fractionCompleted)
                    self.uploadingStatusLabel.isHidden = false
                    self.uploadingStatusLabel.text = "Uploading... \(Int(progress.fractionCompleted * 100)) %"
        } else {
            

           
            }
            }
            
        }
        
        self.view.setNeedsLayout()

        
    }
    
    func reloadData111() {
        PersistenceHelper.fetch(statuses: [PersistenceHelper.UploadStatus.queued, PersistenceHelper.UploadStatus.uploading]) { fetchedResources in
            var oldResources = Set(self.resources)
            self.resources = fetchedResources as! [CloudResource]
            //self.collectionView.reloadData()

            let newResources = Set(self.resources)

            oldResources.subtract(newResources)

            // if something was here before and it's gone now, clean it up from the progress map as well
            for res in oldResources {
                self.progressMap.removeValue(forKey: res.localPath!)
            }
        }
        
    }
   
    // MARK: UIImagePickerControllerDelegate
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
       {
           let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as! URL
           let contentType = info[UIImagePickerController.InfoKey.mediaType] as! String
           let resourceType = contentType.contains("movie") ? CLDUrlResourceType.video : CLDUrlResourceType.image
           Utils.saveImageUrl(imageUrl: imageUrl as URL, contentType: contentType) { url, name in
               if let url = url {
                   // Save to local db
                   PersistenceHelper.addResource(localUri: name!, type: resourceType.description)
                   
                   // upload to cloudinary
                  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                      return
                   }
                //appDelegate.initCloudinary()
//                if let cloudName = UserDefaults.standard.object(forKey: SettingCloudConfig.cloudName) {
//                    appDelegate.cloudinary = CLDCloudinary(configuration: CLDConfiguration(options: ["cloud_name": cloudName as AnyObject])!)
//                          }
                
                let cloudName: String = "dfdoypo9b"//UserDefaults.standard.object(forKey: SettingCloudConfig.cloudName)
                       appDelegate.cloudinary = CLDCloudinary(configuration: CLDConfiguration(options: ["cloud_name": cloudName as AnyObject])!)
                
               guard let cloudinary = appDelegate.cloudinary else {
                    return

               }
                self.viewForUploadingStatus.isHidden = false
                self.heightlayoutConstraint.constant = 70
                
                CloudinaryHelper1.upload(cloudinary: cloudinary , url: url, resourceType: resourceType)
                       .progress({ progress in
                           NotificationCenter.default.post(name: UploadedViewController.progressChangedNotification1, object: nil, userInfo: ["name": name!, "progress": progress])
                       }).response({ response, error in
                           if (response != nil) {
                               PersistenceHelper.resourceUploaded(localPath: name!, publicId: (response?.publicId)!)
                               // cleanup - once a file is uploaded we don't use the local copy
                            DispatchQueue.main.async {
                                self.viewForUploadingStatus.isHidden = true
                                self.heightlayoutConstraint.constant = 0
                                self.imageView.image = nil
                                self.uploadingStatusLabel.text = ""
                            }
                            
                               try? FileManager.default.removeItem(at: url)
                           } else if (error != nil) {
                               PersistenceHelper.resourceError(localPath: name!, code: (error?.code) != nil ? (error?.code)! : -1, description: (error?.userInfo["message"] as? String))
                           }
                       })
               }
           }
           
           // Dismiss the picker.
           dismiss(animated: true, completion: nil)
        
       // reloadData111()
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InProgressViewController") as! InProgressViewController
//        self.present(nextViewController, animated:true, completion:nil)
        
        
       }
       
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
       {
           // Dismiss the picker.
           dismiss(animated: true, completion: nil)
       }
}

protocol UploadedResourceDetails {
    func setResource(resource: CloudResource)
    
}

