//
//  InProgressViewController.swift
//  ImageUpload
//
//  Created by Admin on 9/18/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class InProgressViewController: BaseCollectionViewController {
    static let progressChangedNotification = NSNotification.Name(rawValue: "com.cloudinary.sample.progress.notification")

    // MARK: Properties
    @IBOutlet weak var collectionView1: UICollectionView!
   // @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var plusButtonHidden : UIButton!
    @IBOutlet weak var viewForInProgress: UIView!
    var progressMap: [String: Progress] = [:]

    @IBAction func done(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(InProgressViewController.progressChanged(notification:)), name: InProgressViewController.progressChangedNotification, object: nil)
        getPlusButton()?.createFloatingActionButton()
        getPlusButton()?.isHidden = true
        collectionView1.layer.cornerRadius = 10
        viewForInProgress.layer.cornerRadius = 10
    }
   
    override func getReuseIdentifier() -> String {
        return "ResourceInProgressCell"
    }

    override func getItemsPerRow() -> CGFloat {
        return CGFloat(2);
    }

    override func getCollectionView() -> UICollectionView! {
        return collectionView1
    }
    
    override func getPlusButton() -> UIButton! {
        return plusButtonHidden
    }

    override func reloadData() {
        PersistenceHelper.fetch(statuses: [PersistenceHelper.UploadStatus.queued, PersistenceHelper.UploadStatus.uploading]) { fetchedResources in
            var oldResources = Set(self.resources)
            self.resources = fetchedResources as! [CloudResource]
            
            self.collectionView1.reloadData()

            let newResources = Set(self.resources)

            oldResources.subtract(newResources)

            // if something was here before and it's gone now, clean it up from the progress map as well
            for res in oldResources {
                self.progressMap.removeValue(forKey: res.localPath!)
            }
        }
    }

    @objc func progressChanged(notification: NSNotification) {
        // update progress in map
        let name = notification.userInfo?["name"] as? String
        let progress = notification.userInfo?["progress"] as? Progress

        if (name != nil && progress != nil) {
            progressMap[name!] = progress!
        }

        // refresh views
        collectionView1.reloadData()
    }

   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getReuseIdentifier(), for: indexPath) as! ResourceInProgressCell
        let resource = resources[indexPath.row]
        setLocalImage(imageView: cell.imageView2, resource: resource)
        cell.overlayView2.isHidden = true
        if let progress = progressMap[resource.localPath!] {
            cell.overlayView2.isHidden = false
            cell.progressView2.isHidden = false
            cell.updatingStatusLabel2.isHidden = false
            cell.progressView2.progress = Float(progress.fractionCompleted)
            cell.updatingStatusLabel2.text = "\(Int(progress.fractionCompleted * 100)) %"
        } else {
            cell.overlayView2.isHidden = true
            cell.progressView2.isHidden = true
            cell.updatingStatusLabel2.isHidden = true
        }

        return cell
    }
}
