//
//  MemeMeViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 02/03/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captureImageButton: UIBarButtonItem!
    @IBOutlet var tapGestureRecogniser: UITapGestureRecognizer!
    @IBOutlet weak var containerView: UIView!
    
    //MARK:- Private Variables
    private weak var activeControl: UIView?
    private var textFields = [WeakObjectWrapper<UITextField>]()
    private var memeTextAttributes: [String: AnyObject] {
        get {
            struct DispatchOnce {
                static var token: dispatch_once_t = 0
                static var attributes = [String: AnyObject]()
            }
            dispatch_once(&DispatchOnce.token) {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.setParagraphStyle(NSParagraphStyle.defaultParagraphStyle())
                paragraphStyle.alignment = .Center
                DispatchOnce.attributes = [
                    NSStrokeColorAttributeName: UIColor.blackColor(),
                    NSForegroundColorAttributeName: UIColor.whiteColor(),
                    NSStrokeWidthAttributeName: -3.0,
                    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                    NSParagraphStyleAttributeName: paragraphStyle
                ]
            }
            return DispatchOnce.attributes
        }
    }
    
    //MARK:- Method Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        captureImageButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        tapGestureRecogniser.addTarget(self, action: "handleSingleTap:")
        // Do any additional setup after loading the view.
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
    
    //MARK:- IBActions
    @IBAction func pickImage(sender: AnyObject)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func takeImage(sender: AnyObject)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .Camera
        imagePickerVC.cameraDevice = .Front
        imagePickerVC.cameraCaptureMode = .Photo
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    //MARK:-UITextFieldDelegate Implementation
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeControl = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        if (textField.text ?? "").isEmpty {
            textField.removeFromSuperview()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        activeControl = nil
        return true
    }
    
    //MARK:- UINavigationControllerDelegate Implementation
    func navigationControllerSupportedInterfaceOrientations(navigationController: UINavigationController) -> UIInterfaceOrientationMask
    {
        return .AllButUpsideDown
    }
    
    //MARK:- UIImagePickerControllerDelegate Implementation
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- Action Handlers
    func handleSingleTap(gestureRecogniser: UIGestureRecognizer)
    {
        guard imageView.image != nil else { return }
        removeNilTextFields()
        if textFields.count >= 2 { return }
        let textField = UITextField()
        textField.borderStyle = .None
        textField.clearButtonMode = .Never
        textField.defaultTextAttributes = memeTextAttributes
        textField.autocapitalizationType = .AllCharacters
//        textField.
        textField.delegate = self
        let origin = gestureRecogniser.locationInView(imageView.superview!)
        let frame = CGRectMake(0, origin.y, 100, 50)
        textField.frame = frame
        containerView.addSubview(textField)
        textField.sizeToFit()
        textField.frame.origin.y -= textField.frame.size.height / 2
        textField.frame.size.width = imageView.frame.width
        if textField.canBecomeFirstResponder() { textField.becomeFirstResponder() }
        textFields.append(WeakObjectWrapper(textField))
        activeControl = textField
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        let keyboardHeight = getKeyboardHeight(notification)
        var viewFrame = view.frame
        viewFrame.size.height -= keyboardHeight
        if activeControl != nil {
            var activeControlOrigin = activeControl!.frame.origin
            activeControlOrigin.y += activeControl!.frame.height
            if !CGRectContainsPoint(viewFrame, activeControl!.frame.origin) {
                UIView.animateWithDuration(0.5) { self.view.frame.origin.y -= keyboardHeight }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if view.frame.origin.y != 0 {
            UIView.animateWithDuration(0.5) { self.view.frame.origin.y = 0.0 }
        }
    }
    
    //MARK:- Private Methods
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return keyboardFrame.size.height
    }
    
    private func removeNilTextFields()
    {
        for i in (0 ..< textFields.count).reverse() {
            if textFields[i].item == nil {
                textFields.removeAtIndex(i)
            }
        }
    }
    
}
