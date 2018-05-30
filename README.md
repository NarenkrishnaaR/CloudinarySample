# CloudinarySample

## Configuration:

Signup for free: 
https://cloudinary.com/users/register/free

Create your upload preset name and enable unsigned Mode: https://cloudinary.com/console/settings/upload

## Installation:
```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CloudinarySample' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CloudinarySample
	pod 'Cloudinary', '~> 2.0'
end
```
`pod install` will install the framework in our app.

## Sample Code

**Config your Cloudinary using your cloudname which will be in your dashboard**

```
let cloudinary : CLDCloudinary?
let config = CLDConfiguration(cloudName: "username")
cloudinary = CLDCloudinary(configuration: config)
 ```
**Upload a sample image**

 when you uploading an image in cloudinary an unique id will generate in the url and you can get it in the response.You can fetch the same image by using this id. 
 ```
 cloudinary?.createUploader().upload(data: imageDataFile, uploadPreset: "your upload preset name").response { (result, error) in
      if result != nil{
        if let imageUrl = result?.url{
          let stringToUrl = URL(string: imageUrl)
          let uniqueId = stringToUrl?.lastPathComponent
          UserDefaults.standard.set(imageName, forKey: "uniqueId")
        }
      }
    }
  ```

**Fetch an uploaded image from Cloudinary** 

```
if let imagePublicId = UserDefaults.standard.value(forKey: "uniqueId") as? String{
      imgView.cldSetImage((cloudinary?.createUrl().generate(imagePublicId))!, cloudinary: cloudinary!)
 }
  ```
 
