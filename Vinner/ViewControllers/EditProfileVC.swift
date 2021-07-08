//
//  EditProfileVC.swift
//  Vinner
//
//  Created by softnotions on 23/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import MobileCoreServices
import Alamofire
import SwiftyJSON
import PhotosUI
import Photos

class EditProfileVC: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var scrollProfile: UIScrollView!
    var pUpdateModel:ProfileUpRespModel?
    var profileModel:ProfileModel?
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDistrict: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPost: UITextField!
    @IBOutlet weak var txtArea: UITextField!
    @IBOutlet weak var txtHouse: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgEditProfile: SDAnimatedImageView!
    @IBOutlet weak var lblName: UILabel!
    var timage = UIImage()
    
    let sharedData = SharedDefault()
    var firstImgData:String = String()
    
    var dropTextField = UITextField()
    
    override func viewWillDisappear(_ animated: Bool) {
        dropTextField.removeFromSuperview()
    }
    override func viewDidAppear(_ animated: Bool) {
      //  self.addTextfield()
      //  self.addCustControls()
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.addTextfield()
       // self.addCustControls()
        //self.navigationController?.navigationBar.topItem?.title = "Profile Edit"
        self.addBackButton(title: "Profile Edit")
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.addCustControls()
        //self.addTextfield()
        txtMobile.delegate = self
        txtEmail.delegate = self
        txtDistrict.delegate = self
//        txtState.delegate = self
        txtPost.delegate = self
        txtArea.delegate = self
        txtHouse.delegate = self
        txtName.delegate = self
        txtMobile.isEnabled = false
        self.addBottomBorderTextfield(textField: self.txtMobile,placeHolderText: "Mobile")
        self.addBottomBorderTextfield(textField: self.txtEmail,placeHolderText: "Email")
        self.addBottomBorderTextfield(textField: self.txtDistrict,placeHolderText: "City")
//        self.addBottomBorderTextfield(textField: self.txtState,placeHolderText: "State")
        self.addBottomBorderTextfield(textField: self.txtPost,placeHolderText: "Post")
        self.addBottomBorderTextfield(textField: self.txtArea,placeHolderText: "Area / Location / Street")
        self.addBottomBorderTextfield(textField: self.txtHouse,placeHolderText: "House Name / Door No")
        self.addBottomBorderTextfield(textField: self.txtName,placeHolderText: "Name")
        btnSubmit.layer.cornerRadius = 5
        
        self.getProfileDetails()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
           
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openGallery))
        imgEditProfile.addGestureRecognizer(tap)
        imgEditProfile.isUserInteractionEnabled = true
        
        
        
        imgEditProfile.layer.cornerRadius = imgEditProfile.frame.size.height/2

    }
    @objc func openGallery()
    {
        print("Tapped on Image")
//        self.showAlert()
    }
    @IBAction func ActionCamera(_ sender: Any)
    {
        self.showAlert()

    }
    
    func addTextfield()  {
        
        
        dropTextField =  UITextField(frame: CGRect(x: self.view.frame.size.width-275, y: 5, width: 180, height: 30))
        
        dropTextField.placeholder = "Select Region"
        dropTextField.font = UIFont.systemFont(ofSize: 15)
        dropTextField.borderStyle = UITextField.BorderStyle.roundedRect
        dropTextField.autocorrectionType = UITextAutocorrectionType.no
        dropTextField.keyboardType = UIKeyboardType.default
        dropTextField.returnKeyType = UIReturnKeyType.done
        dropTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        dropTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
       //self.navigationController?.navigationBar.topItem?.titleView = dropTextField
     
     self.navigationController?.navigationBar .addSubview(dropTextField)
        dropTextField.layer.cornerRadius = 15
        let viewImg = UIView(frame: CGRect(x: 0, y: dropTextField.frame.size.height/2, width: 10, height: 10))
        dropTextField.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 10, height: 10))
        let image = UIImage(named: "DownArrow")
        imageView.image = image
        viewImg.addSubview(imageView)
        dropTextField.rightView = viewImg
    }
    
    func getProfileDetails(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
        
        let loginURL = Constants.baseURL+Constants.profileDetailURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
                
                if error._code == NSURLErrorTimedOut {
                    self.showToast(message: "Request timed out! Please try again!")
                }
                else if error._code == 4 {
                    self.showToast(message: "Internal server error! Please try again!")
                }
                else if error._code == -1003 {
                    self.showToast(message: "Server error! Please contact support!")
                }
            case .success :
                do {
                    let response = JSON(data.data!)
                    self.profileModel = ProfileModel(response)
                    let statusCode = Int((self.profileModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
                            self.imgEditProfile.sd_setImage(with: URL(string: (self.profileModel?.profileData?.path!)!), placeholderImage: UIImage(named: "Transparent"))
                           //
                            self.lblName.text = self.profileModel?.profileData?.name!
                            
                            if (self.profileModel?.profileData?.mobile!.count)! > 7
                            {
//                                    self.txtMobile.text =  self.sharedData.getCountyCode() + " " + (self.profileModel?.profileData?.mobile!)!
                                if self.sharedData.getCountyCode().contains("+")
                                {
                                    self.txtMobile.text =  self.sharedData.getCountyCode() + " " + (self.profileModel?.profileData?.mobile!)!
                                }
                                else
                                {
                                        self.txtMobile.text = "+" + self.sharedData.getCountyCode() + " " + (self.profileModel?.profileData?.mobile!)!

                                }
                            }
                            else
                            {
                                
                            self.txtMobile.text = "+" + " " + (self.profileModel?.profileData?.mobile!)!
                            
                            }
                            self.txtEmail.text = self.profileModel?.profileData?.email!
                            self.txtDistrict.text = self.profileModel?.profileData?.city!
//                                self.txtState.text = self.profileModel?.profileData?.state!
                            self.txtPost.text = self.profileModel?.profileData?.post!
                            self.txtArea.text = self.profileModel?.profileData?.address2!
                            self.txtHouse.text = self.profileModel?.profileData?.address1!
                            self.txtName.text = self.profileModel?.profileData?.name!
                            
                            self.view.activityStopAnimating()
//                        }
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.profileModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    

    func updateProfile(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        //mobilevalue.dropFirst(1)
        let mobilevalue = txtMobile.text!
        postDict = [
            "access_token":sharedData.getAccessToken(),
            "name":txtName.text!,
            "address1":txtHouse.text!,
            "address2":txtArea.text!,
            "post":txtPost.text!,
//            "state":txtState.text!,
            "mobile":String(mobilevalue.dropFirst(5)),
            "c_code":sharedData.getCountyCode(),
            "email":txtEmail.text!,
            "city":txtDistrict.text!,
            "profile_pic":firstImgData
        ]
        
        let loginURL = Constants.baseURL+Constants.profileUpdateURL
        print("loginURL",loginURL)
        print("postDict",postDict)
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
                
                if error._code == NSURLErrorTimedOut {
                    self.showToast(message: "Request timed out! Please try again!")
                }
                else if error._code == 4 {
                    self.showToast(message: "Internal server error! Please try again!")
                }
                else if error._code == -1003 {
                    self.showToast(message: "Server error! Please contact support!")
                }
            case .success :
                do {
                    let response = JSON(data.data!)
                    self.pUpdateModel = ProfileUpRespModel(response)
                    let statusCode = Int((self.pUpdateModel?.httpcode)!)
                    if statusCode == 200{
                        self.showToast(message: (self.pUpdateModel?.message)!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                             
                            self.view.activityStopAnimating()
//                            self.saveImage(imageName: "ProfileImage", image: self.timage)
                            self.saveImage(imageName: "ProfileImage_\(self.txtName.text!)", image: self.timage)

                            self.sharedData.setProfileName(token:self.txtName.text!)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.pUpdateModel?.message)!)
                        self.deleteDirectory(sFileNme: "ProfileImage")

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }

    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        
        if txtName.text!.count <= 0 {
            self.showToast(message: Constants.profileNameEmptyMsg)
        }
        else if txtHouse.text!.count <= 0 {
            self.showToast(message: Constants.profileHNameEmptyMsg)
        }
        else if txtArea.text!.count <= 0 {
            self.showToast(message: Constants.profileAreaEmptyMsg)
        }
        else if txtPost.text!.count <= 0 {
            self.showToast(message: Constants.profilePostEmptyMsg)
        }
//        else if txtState.text!.count <= 0 {
//            self.showToast(message: Constants.profileStateEmptyMsg)
//        }
        else if txtDistrict.text!.count <= 0 {
            self.showToast(message: Constants.profileDistEmptyMsg)
        }
        else if txtEmail.text!.count <= 0 {
            self.showToast(message: Constants.profileEmailEmptyMsg)
        }
        else if txtMobile.text!.count <= 0 {
            self.showToast(message: Constants.profileMobileEmptyMsg)
        }
        else {
            self.updateProfile()
        }
        
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollProfile.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollProfile.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollProfile.contentInset = contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("shouldChangeCharactersIn")

if textField == txtName || textField == txtDistrict
{
    let allowedCharacter = CharacterSet.letters
    let allowedCharacter1 = CharacterSet.whitespaces
    let characterSet = CharacterSet(charactersIn: string)
    return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
}
else
{
    return true
}

}
    
    //Show alert to selected the media source type.
    func showAlert() {
        
        //        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        //        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
        //           // self.type = 1
        //            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
        //                // Already Authorized
        //                self.getImage(fromSourceType: .camera)
        //            } else {
        //                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
        //                   if granted == true {
        //                       // User granted
        //                    self.getImage(fromSourceType: .camera)
        //                   } else {
        //                       // User rejected
        //                   }
        //               })
        //            }
        //        }))
        //        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
        //
        //            if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        //                   {
        //                      self.getImage(fromSourceType: .photoLibrary)
        //                   }
        //                   else
        //                   {
        //                      PHPhotoLibrary.requestAuthorization { (status) in
        //                          // cruch here
        //                        self.getImage(fromSourceType: .photoLibrary)
        //                      }
        //                   }
        //        }))
        //        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        //        self.present(alert, animated: true, completion: nil)
                
                let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
                    self.getImage(fromSourceType: .camera)
                }))
                alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
                    self.getImage(fromSourceType: .photoLibrary)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                
                
            }
    //get image from source type
       func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.modalPresentationStyle = .fullScreen
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Info ------->",info as Any)
        if let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            print(asset?.value(forKey: "filename") as Any)
        }
        let pImage = info[UIImagePickerController.InfoKey.originalImage]
        timage = (pImage as? UIImage)!
        firstImgData = convertImageToBase_64(image: timage.jpeg(UIImage.JPEGQuality(rawValue: 0.0)!)!)
        
        imgEditProfile.image = timage


        // btnProfilePic.setImage(pImage as? UIImage, for: .normal)
        //updateDetails["avatar"] = convertImageToBase64(image: ((pImage as? UIImage)!))
        dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.activityStartAnimating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.view.activityStopAnimating()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
    
    func saveImage(imageName: String, image: UIImage) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }

    }
    func deleteDirectory(sFileNme:String)
    {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = sFileNme
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }

        }
    }
    
}
