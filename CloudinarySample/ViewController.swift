//
//  ViewController.swift
//  CloudinarySample
//
//  Created by Naren on 29/05/18.
//  Copyright © 2018 naren. All rights reserved.
//

import UIKit
import CloudKit
import Cloudinary

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  @IBOutlet weak var imgView: UIImageView!
  
  let config = CLDConfiguration(cloudName: CloudinarySetup.USER_NAME.rawValue)
  var imagePicker = UIImagePickerController()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupCloudinaryForImageUpload(){
    let cloudinary = CLDCloudinary(configuration: config)
    
    cloudinary.createUploader().upload(data: UserDefaults.standard.data(forKey: "imageData")!, uploadPreset: "oomxc0og").response { (result, error) in
      if result != nil{
        if let imageUrl = result?.url{
          let stringToUrl = URL(string: imageUrl)
          let imageName = stringToUrl?.lastPathComponent
          UserDefaults.standard.set(imageName, forKey: "uploadedImageName")
          AlertView.alertFunc(viewController: self, title: "Image Uploaded Successfully", message: "", buttonTitle: "Ok")
        }
      }else{
        AlertView.alertFunc(viewController: self, title: (error?.localizedDescription)!, message: "", buttonTitle: "Ok")
        print(error)
      }
    }
  }
  
  @IBAction func btnUploadFunc(_ sender: Any) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func btnFetchFromCloudinaryFunc(_ sender: Any) {
    let cloudinary = CLDCloudinary(configuration: config)
    cloudinary.createUrl().setTransformation(CLDTransformation.init().setw)
    if let imagePublicId = UserDefaults.standard.value(forKey: "uploadedImageName") as? String{
      imgView.cldSetImage(cloudinary.createUrl().generate(imagePublicId)!, cloudinary: cloudinary)
      //      if let imageUrl = cloudinary.createUrl().generate(imagePublicId){
      //        let downloader:CLDDownloader = cloudinary.createDownloader()
      //        downloader.fetchImage(imageUrl).response { (response, error) in
      //          if response != nil{
      //            self.imgView.image = response as? UIImage
      //          }else{
      //            print(error)
      //          }
      //        }
      //      }
    }
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
      let imgName = imgUrl.lastPathComponent
      let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
      let localPath = documentDirectory?.appending(imgName)
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      let data = UIImagePNGRepresentation(image)! as NSData
      data.write(toFile: localPath!, atomically: true)
      if let imageData = image.jpeg(.low){
        UserDefaults.standard.set(imageData, forKey: "imageData")
      }
      //let imageData = NSData(contentsOfFile: localPath!)!
      let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
      
      UserDefaults.standard.set(photoURL, forKey: "imageUrl")
      setupCloudinaryForImageUpload()
      print(photoURL)
      dismiss(animated: true, completion: nil)
    }
  }
}

