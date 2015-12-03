//
//  ViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/3/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    var savedMemes = [Meme]()
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: Actions
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let imagePicker = getImagePicker()
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = getImagePicker()
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let shareMenu = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareMenu.completionWithItemsHandler = {
            activitiyType, completed, returnedItems, activityError in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(shareMenu, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        imageView.image = nil
        shareButton.enabled = false
    }
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        self.shareButton.enabled = (imageView.image != nil)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Custom methods
    private func getImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }
    
    private func setupTextFields() {
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as? NSMutableParagraphStyle
        paragraphStyle?.alignment = NSTextAlignment.Center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0,
            NSParagraphStyleAttributeName : paragraphStyle!
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide navbar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Show navbar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image, memedImage: generateMemedImage())
        savedMemes.append(meme)
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTextField && topTextField.text == defaultTopText {
            textField.text = ""
        } else if textField == bottomTextField && bottomTextField.text == defaultBottomText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Move the view when the keyboard covers the text field
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.editing {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y < 0 {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

