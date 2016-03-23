//
//  ViewController.swift
//  Meme Me
//
//  Created by Maarut Chandegra on 29/02/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {

    // MARK: - IBOutlet's
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Private variables
    private weak var activeControl: UIView?
    private var originalContentOffset: CGPoint?
    
    // MARK: - Public variable
    
    var memeModel: MemeModel?
    
    // MARK: - UIViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        takePictureButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        setUpTextField(topTextField, text: "ENTER TEXT HERE...", attributes: MemeAttributes.attributes())
        setUpTextField(bottomTextField, text: "...AND HERE", attributes: MemeAttributes.attributes())
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardDidHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        if let memeModel = memeModel {
            topTextField.text = memeModel.topTextField
            bottomTextField.text = memeModel.bottomTextField
            topTextField.hidden = false
            bottomTextField.hidden = false
            imageView.image = memeModel.originalImage
            scrollView.zoomScale = CGFloat(memeModel.zoomScale)
            scrollView.contentOffset = memeModel.contentOffset
            scrollView.contentSize = memeModel.contentSize
        }
        shareButton.enabled = imageView.image != nil
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        memeModel = nil
    }
    
    // MARK: - IBAction's
        
    @IBAction func chooseImage(sender: AnyObject)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func captureImage(sender: AnyObject)
    {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .Camera
        imagePickerVC.cameraDevice = .Front
        imagePickerVC.cameraCaptureMode = .Photo
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject)
    {
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        scrollView.zoomScale = 1.0
        imageView.image = nil
        topTextField.hidden = true
        bottomTextField.hidden = true
        topTextField.text = "ENTER TEXT HERE..."
        bottomTextField.text = "...AND HERE"
        shareButton.enabled = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject)
    {
        let image = composeImage()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            if completed {
                self.saveMemeUsingComposedImage(image)
            }
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return imageView
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
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        scrollView.zoomScale = 1.0
        shareButton.enabled = imageView.image != nil
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // MARK: - Keyboard Notification Handlers
    
    func keyboardWillShow(notification: NSNotification)
    {
        let keyboardHeight = getKeyboardHeight(notification)
        var viewFrame = view.frame
        viewFrame.size.height -= keyboardHeight
        if let activeControl = activeControl {
            var bottomOfControl = activeControl.frame.origin
            bottomOfControl.y += activeControl.frame.height
            if !CGRectContainsPoint(viewFrame, bottomOfControl) {
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
                originalContentOffset = scrollView.contentOffset
                UIView.animateWithDuration(0.5) { self.view.frame.origin.y -= keyboardHeight }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func keyboardDidHide(notification: NSNotification)
    {
        if let originalContentOffset = originalContentOffset {
            scrollView.contentOffset = originalContentOffset
            scrollView.contentInset = UIEdgeInsetsZero
            self.originalContentOffset = nil
        }
    }

    // MARK: - Private Functions
    
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

    private func composeImage() -> UIImage
    {
        var drawingFrame = containerView.frame
        drawingFrame.origin = CGPointZero
        drawingFrame.size.height *= UIScreen.mainScreen().scale
        drawingFrame.size.width *= UIScreen.mainScreen().scale
        UIGraphicsBeginImageContext(drawingFrame.size)
        containerView.drawViewHierarchyInRect(drawingFrame, afterScreenUpdates: true)
        let composedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return composedImage
    }
    
    private func saveMemeUsingComposedImage(image: UIImage)
    {
        let meme = MemeModel(topTextField: topTextField.text ?? "",
            bottomTextField: bottomTextField.text ?? "",
            originalImage: imageView.image!,
            composedImage: image,
            contentOffset: scrollView.contentOffset,
            contentSize: scrollView.contentSize,
            zoomScale: Float(scrollView.zoomScale))
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
    }
    
    private func setUpTextField(textField: UITextField, text: String, attributes: [String: AnyObject])
    {
        textField.delegate = self
        textField.defaultTextAttributes = attributes
        textField.attributedText = NSAttributedString(string: text, attributes: attributes)
        textField.hidden = true
        containerView.bringSubviewToFront(textField)
    }
    
}

