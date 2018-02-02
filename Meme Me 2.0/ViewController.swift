//
//  ViewController.swift
//  Meme Me V1
//
//  Created by Anthony Rubin on 12/22/17.
//  Copyright © 2017 Anthony Rubin. All rights reserved.
//

import UIKit
import AVFoundation

struct Meme {
    var upperText: String
    var lowerText: String
    var originalImage: UIImage
    var memeImage: UIImage
}

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate
{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        upperTextField.resignFirstResponder()
        lowerTextField.resignFirstResponder()
        return false
    }

  
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black ,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0
    ]
   
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var upperToolBar: UIToolbar!
    
    @IBOutlet weak var upperTextField: UITextField!
    
    @IBOutlet weak var lowerTextField: UITextField!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
  
    @IBOutlet weak var lowerToolBar: UIToolbar!
    
    
    var topConstraint : NSLayoutConstraint!
    var bottomConstraint : NSLayoutConstraint!
    var trailingConstraint : NSLayoutConstraint!
   
    var activityViewController:UIActivityViewController?
    
    func layoutTextFields() {
    //Remove any existing constraints
    if topConstraint != nil {
    view.removeConstraint(topConstraint)
    }
    
    if bottomConstraint != nil {
    view.removeConstraint(bottomConstraint)
    }
        
   if trailingConstraint != nil {
        view.removeConstraint(trailingConstraint)
    }
  
        
    
    //Get the position of the image inside the imageView
    let size = memeImageView.image != nil ? memeImageView.image!.size : memeImageView.frame.size
        let frame =  AVMakeRect(aspectRatio: size, insideRect: memeImageView.bounds)
    
    //A margin for the new constrains; 10% of the frame's height
    let margin = frame.origin.y + frame.size.height * 0.10
    let align = frame.origin.x
    
    //Create and add the new constraints
   
        //NOTIFICATION: I found the code to programatically set the top and bottom constraints on stackoverflow.  However I learned from this code and figured out how to set the trailing constraints myself.
    
    //top Constraint for the upperTextField
    topConstraint = NSLayoutConstraint(
        item: upperTextField,
        attribute: .top,
        relatedBy: .equal,
        toItem: memeImageView,
        attribute: .top,
        multiplier: 1.0,
        constant: margin)
    view.addConstraint(topConstraint)
    
    //bottom Constraingt for the lowerTextField
    bottomConstraint = NSLayoutConstraint(
        item: lowerTextField,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: memeImageView,
        attribute: .bottom,
        multiplier: 1.0,
        constant: -margin)
    view.addConstraint(bottomConstraint)
        
    //trailing Constraint for the upperTextField
    trailingConstraint = NSLayoutConstraint(
        item: upperTextField,
        attribute: .trailingMargin,
        relatedBy: .equal,
        toItem: view,
        attribute: .trailingMargin,
        multiplier: 1.0,
        constant: -align)
    view.addConstraint(trailingConstraint)
        
        trailingConstraint = NSLayoutConstraint(
            item: lowerTextField,
            attribute: .trailingMargin,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailingMargin,
            multiplier: 1.0,
            constant: -align)
        view.addConstraint(trailingConstraint)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        if memeImageView.image != nil {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTextFields()
    }
    
    func configureTextField(textField: UITextField, withTextAttributes: [String:Any], withText: String, withDelegate: ViewController, withTextAlignment: NSTextAlignment ){
        textField.defaultTextAttributes = withTextAttributes
        textField.text = withText
        textField.delegate = withDelegate
        textField.textAlignment = withTextAlignment
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(textField: upperTextField, withTextAttributes: memeTextAttributes, withText: "TOP", withDelegate: self, withTextAlignment: .center)
        configureTextField(textField: lowerTextField, withTextAttributes: memeTextAttributes, withText: "BOTTOM", withDelegate: self, withTextAlignment: .center)
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if (upperTextField == textField){
            upperTextField.text = ""
        } else if (lowerTextField == textField){
            lowerTextField.text = ""
        }
    }
    
 func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
    self.memeImageView.image = selectedImage
    dismiss(animated: true, completion: nil)
    
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if lowerTextField.isEditing{
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        if lowerTextField.resignFirstResponder() == true {
        view.frame.origin.y = view.frame.origin.y + getKeyboardHeight(notification)
        } else {
            view.frame.origin.y = 0
        }
    }

    
    func chooseSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
         present(imagePicker, animated: true, completion: nil)
    }
    
   @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    chooseSourceType(sourceType: .photoLibrary)
   }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseSourceType(sourceType: .camera)
    }
    

       func generateMemedImage() -> UIImage {
        
        //Turn the view background color to black
        self.view.backgroundColor = UIColor.black
        //Hide toolbar and navbar
        self.upperToolBar.isHidden = true
        self.lowerToolBar.isHidden = true
            
            // Render view to an image
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            // Show toolbar and navbar
            self.upperToolBar.isHidden = false
            self.lowerToolBar.isHidden = false
        //turn the background color back to its original white color
        self.view.backgroundColor = UIColor.white
            return memedImage
        }
    
    func save() {
        // Create the meme
        let meme = Meme(upperText: upperTextField.text!, lowerText: lowerTextField.text!, originalImage: memeImageView.image!, memeImage: generateMemedImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @IBAction func shareText(_ sender: Any) {
        let meme = generateMemedImage()
        let activityViewController = UIActivityViewController(
            activityItems: [meme],
            applicationActivities: nil)
         present(activityViewController, animated: true, completion: nil)
   
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if success{
                self.save()
                self.activityViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

