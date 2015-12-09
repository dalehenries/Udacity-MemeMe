//
//  ViewController.swift
//  MemeMe
//
//  Created by Dale Henries on 12/3/15.
//  Copyright © 2015 Samaritan's Purse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Properties
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    //var savedMemes = [Meme]()
    
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = getImagePicker()
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let shareMenu = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareMenu.completionWithItemsHandler = {
            activitiyType, completed, returnedItems, activityError in
            self.save(memedImage)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(shareMenu, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = (imageView.image != nil)
        subscribeToKeyboardNotifications()
        self.navigationController?.toolbarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.navigationController?.toolbarHidden = true
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
        // Hide navbar
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: false)
        
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show navbar
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image, memedImage: memedImage)
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.memes.append(meme)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    
}

// MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: UITextField Delegate
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
        // only move view up if we're editing the bottom text field
        if bottomTextField.editing {
            // only move the view up if it hasn't already been moved up
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // only move the view down if it has previously been moved up
        if view.frame.origin.y < 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
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

