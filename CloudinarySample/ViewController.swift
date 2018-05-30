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

class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
  
  
  @IBOutlet weak var imgView: UIImageView!
  
  var imagePicker = UIImagePickerController()
  var height = ""
  var width = ""
  let cloudinary = CloudinaryMethods.init().cloudinary
  let effectsType = ["sepia","blur","blue"]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setupCloudinaryForImageUpload(){
    cloudinary?.createUploader().upload(data: UserDefaults.standard.data(forKey: "imageData")!, uploadPreset: "oomxc0og").response { (result, error) in
      if result != nil{
        if let imageUrl = result?.url{
          let stringToUrl = URL(string: imageUrl)
          let imageName = stringToUrl?.lastPathComponent
          UserDefaults.standard.set(imageName, forKey: "uploadedImageName")
          AlertView.alertFunc(viewController: self, title: "Image Uploaded Successfully", message: "", buttonTitle: "Ok")
        }
      }else{
        AlertView.alertFunc(viewController: self, title: (error?.localizedDescription)!, message: "", buttonTitle: "Ok")
      }
    }
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return effectsType.count
  }
  
  @IBAction func btnUploadFunc(_ sender: Any) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }
  
  @IBAction func btnFetchFromCloudinaryFunc(_ sender: Any) {
    if let imagePublicId = UserDefaults.standard.value(forKey: "uploadedImageName") as? String{
      imgView.cldSetImage((cloudinary?.createUrl().generate(imagePublicId))!, cloudinary: cloudinary!)
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
  
  @IBAction func btnCropImage(_ sender: Any) {
    
    let alertController = UIAlertController(title: "Set Height anf Width", message: "", preferredStyle: .alert)
    alertController.addTextField { (textField : UITextField!) -> Void in
      textField.placeholder = "Width"
    }
    let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alert -> Void in
      let firstTextField = alertController.textFields![0] as UITextField
      let secondTextField = alertController.textFields![1] as UITextField
      self.height = firstTextField.text ?? ""
      self.width = secondTextField.text ?? ""
      if let imageId = UserDefaults.standard.value(forKey: "uploadedImageName") as? String{
        if let url = self.cloudinary?.createUrl().setTransformation(CLDTransformation().setHeight(self.height).setWidth(self.width)).generate(imageId)!{
          self.imgView.cldSetImage(url, cloudinary: self.cloudinary!)
        }
      }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
      (action : UIAlertAction!) -> Void in })
    alertController.addTextField { (textField : UITextField!) -> Void in
      textField.placeholder = "Height"
    }
    alertController.addAction(saveAction)
    alertController.addAction(cancelAction)
    self.present(alertController, animated: true, completion: nil)
  }
  
  
  @IBAction func btnEffectForImage(_ sender: Any) {
    
    let picker: UIPickerView
    picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
    picker.backgroundColor = UIColor.white
    
    picker.showsSelectionIndicator = true
    picker.delegate = self
    picker.dataSource = self
    
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    toolBar.sizeToFit()
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: Selector("donePicker"))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector(("donePicker")))
    
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    
    if let imageId = UserDefaults.standard.value(forKey: "uploadedImageName") as? String{
      if let url = self.cloudinary?.createUrl().setTransformation(CLDTransformation().setHeight(self.height).setWidth(self.width)).generate(imageId)!{
        self.imgView.cldSetImage(url, cloudinary: self.cloudinary!)
      }
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

