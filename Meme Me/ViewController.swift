//
//  ViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 29/02/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - IBOutlet's
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // MARK: - Private variables
    private weak var activeControl: UIView?
    
    // MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        takePictureButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
        paragraphStyle.alignment = .Center
        let textFieldAttributes/*: [String: AnyObject]*/ = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSStrokeWidthAttributeName: -3.0,
            NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
            NSParagraphStyleAttributeName: paragraphStyle
        ]
        topTextField.defaultTextAttributes = textFieldAttributes
        bottomTextField.defaultTextAttributes = textFieldAttributes
        topTextField.attributedText = NSAttributedString(string: "Enter text here...", attributes: textFieldAttributes)
        bottomTextField.attributedText = NSAttributedString(string: "...and here", attributes: textFieldAttributes)
        topTextField.hidden = true
        bottomTextField.hidden = true
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBAction's
        
    @IBAction func chooseImage(sender: AnyObject)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func captureImage(sender: AnyObject)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .Camera
        imagePickerVC.cameraDevice = .Front
        imagePickerVC.cameraCaptureMode = .Photo
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        clearTextField(textField)
        activeControl = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeControl = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UINavigationViewControllerDelegate Methods
    
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask
    {
        return .AllButUpsideDown
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        topTextField.hidden = false
        bottomTextField.hidden = false
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Keyboard Notification Handlers
    
    func keyboardWillShow(notification: NSNotification)
    {
        let keyboardHeight = getKeyboardHeight(notification)
        var viewFrame = view.frame
        viewFrame.size.height -= keyboardHeight
        if activeControl != nil && !CGRectContainsPoint(viewFrame, activeControl!.frame.origin) {
            UIView.animateWithDuration(0.5) { self.view.frame.origin.y -= keyboardHeight }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if view.frame.origin.y != 0 {
            UIView.animateWithDuration(0.5) { self.view.frame.origin.y = 0.0 }
        }
    }
    
    // MARK: - Private Function
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return keyboardFrame.size.height
    }
    
    private func clearTextField(textField: UITextField)
    {
        switch textField {
        case topTextField:
            if let text = textField.text {
                if text.caseInsensitiveCompare("Enter text here...") == .OrderedSame {
                    textField.text = nil
                }
            }
            break
        case bottomTextField:
            if let text = textField.text {
                if text.caseInsensitiveCompare("...and here") == .OrderedSame {
                    textField.text = nil
                }
            }
            break
        default:
            break
        }
    }

    
}

