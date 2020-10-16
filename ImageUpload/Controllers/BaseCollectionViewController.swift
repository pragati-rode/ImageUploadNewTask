//
//  BaseGridViewController.swift
//  ImageUpload
//
//  Created by Admin on 9/16/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class BaseCollectionViewController: UIViewController {

    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    var resources = [CloudResource]()
    let collectionViewColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0);
    
//    let textNewColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1.0);

    // MARK: ViewController
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(BaseCollectionViewController.reloadData), name: PersistenceHelper.resouceChangedNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCollectionView().dataSource = self
        getCollectionView().delegate = self
        getCollectionView().backgroundColor = collectionViewColor
       
        getCollectionView().translatesAutoresizingMaskIntoConstraints = false
        getPlusButton().createFloatingActionButton()
        reloadData()
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        // init cloudinary now that there's a cloud name present
//        appDelegate.initCloudinary()
    }

    // NOP methods, concrete implementations in subclasses.
    @objc func reloadData() {
    }

    // NOP methods, concrete implementations in subclasses.
    func getCollectionView() -> UICollectionView! {
        return nil
    }
   
    func getView() -> UIView! {
        return nil
    }
    
    func getPlusButton() -> UIButton! {
        return nil
    }

    // default items per row
    func getItemsPerRow() -> CGFloat {
        return CGFloat(2);
    }

    // default cell type for resource collections
    func getReuseIdentifier() -> String {
        return "ResourceCell"
    }
}

extension UIViewController {
    func getAppDelegate() -> AppDelegate? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate
        }

        return nil
    }
    
    func downloadImagefrmCloud(resource: CloudResource, imgView: UIImageView){
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
             return
          }
              let progressHandler = { (progress: Progress) in
                  print("Downloading from Cloudinary: \(Int(progress.fractionCompleted * 100))%")
              }
           
              let url1 =  "https://res.cloudinary.com/dfdoypo9b/image/upload/v1601278669/tl9q3popioo1btuedyjr.jpg"
        let urlString2  = CloudinaryHelper1.getUrlForTransformation(appDelegate.cloudinary, CLDTransformation(), resource)
              print(url1)
              let url = URL(string: urlString2)
              
        appDelegate.cloudinary.createDownloader().fetchImage(urlString2, progressHandler, completionHandler: { (result,error) in
                  
                  if let error = error {
                      print("Error downloading image %@", error)
                  }
                  else {
                      print("Image downloaded from Cloudinary successfully")
                      
                      do{
                          let data = try Data(contentsOf: url!)
                          DispatchQueue.main.async {
                          imgView.image = UIImage(data: data)
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

extension BaseCollectionViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        if resources.isEmpty {
            
            if getReuseIdentifier() == "ResourceCell" {
                getCollectionView()?.setEmptyMessage("Tap on ", "plus.circle", " to upload images")
            }
            else {
                getCollectionView()?.setEmptyMessage(" No Uploads remaining ", "", "")
            }
            
            return 0
            
        } else {
         //   getCollectionView()?.backgroundColor = UIColor.white
            getView()?.backgroundColor = UIColor.white
            getCollectionView().restore()
        }
        
        return resources.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReuseIdentifier(), for: indexPath) as! ResourceCell
        cell.layer.cornerRadius = 25
        cell.layer.masksToBounds = true
        //cell.imageView.layer.cornerRadius = 25
        cell.imgView.layer.cornerRadius = 25
        let resource = resources[indexPath.row]
        if (resource.publicId != nil) {
            // remote image, smart fetch from Cloudinary:
            // first set placeholder
           // cell.imageView.image = resource.resourceType!.contains("video") ? UIImage(named: "ic_movie_white") : UIImage(named: "ic_cloudinary")
 cell.imgView.image = resource.resourceType!.contains("video") ? UIImage(named: "ic_movie_white") : UIImage(named: "ic_cloudinary")
            
            self.downloadImagefrmCloud(resource: resource, imgView: cell.imgView)
            // configure params for image fetch:
           // let resourceType = resource.resourceType == "video" ? CLDUrlResourceType.video : CLDUrlResourceType.image
           // let params = CLDResponsiveParams.fit().setReloadOnSizeChange(true)
           
         //   let params = CLDResponsiveParams.fit().setReloadOnSizeChange(true)
          //  let params = CLDResponsiveParams(autoWidth: true, autoHeight: true, cropMode: .fill, gravity: .auto)
          /* cell.imageView.cldSetImage(publicId: resource.publicId!, cloudinary: getAppDelegate()!.cloudinary, resourceType: resourceType,
                    responsiveParams: params, transformation: CLDTransformation().setFetchFormat("jpg"))*/
            
           // print("Height ==> ",cell.imageView.image?.size.height ?? 200)
          //  cell.imageView.contentMode = .scaleAspectFill
           // cell.imageView.contentMode = .scaleAspectFit
        } else {
           // setLocalImage(imageView: cell.imageView, resource: resource)
            setLocalImage(imageView: cell.imgView, resource: resource)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }

    internal func setLocalImage(imageView: UIImageView, resource: CloudResource) {
        if let image = Utils.getImage(relativePath: resource.localPath!) {
            imageView.image = image
            imageView.contentMode = UIView.ContentMode.scaleAspectFill
        } else {
            imageView.image = resource.resourceType!.contains("video") ? UIImage(named: "ic_movie_white") : UIImage(named: "ic_cloudinary")
            imageView.contentMode = UIView.ContentMode.center
        }
    }
}

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow = getItemsPerRow()
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = collectionView.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
////
//        let cell = collectionView.cellForItem(at: indexPath) as? ResourceCell
//        let height = cell?.imageView.image?.size.height ?? 300
//        print("height == > ", height)
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
        

       
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
   
}

extension UICollectionView {
 //let textNewColor = UIColor(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1.0);
    func setEmptyMessage(_ message: String, _ imageName : String, _ message2: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        let iconsSize = CGRect(x: 0, y: -5, width: 35, height: 35)
        
        let attributedString = NSMutableAttributedString(string: message)
        let loveAttachment = NSTextAttachment()
        if imageName != "" {
        loveAttachment.image = UIImage(systemName: imageName)
        loveAttachment.image = loveAttachment.image?.withRenderingMode(.alwaysTemplate)
        loveAttachment.image?.withTintColor(UIColor(red: 96/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1.0))
        loveAttachment.bounds = iconsSize
        attributedString.append(NSAttributedString(attachment: loveAttachment))
        }
       attributedString.append(NSAttributedString(string: message2))
        
       // messageLabel.text = message
        messageLabel.attributedText = attributedString
        messageLabel.textColor = UIColor(red: 96/255.0, green: 96/255.0, blue: 96/255.0, alpha: 1.0)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Damascus", size: 35)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
    
    
}

extension UIButton {
    func createFloatingActionButton() {
        backgroundColor = UIColor.black
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }
}
