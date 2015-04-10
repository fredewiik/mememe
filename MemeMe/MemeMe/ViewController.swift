//
//  ViewController.swift
//  MemeMe
//
//  Created by Frédéric Lépy on 06/04/2015.
//  Copyright (c) 2015 Frédéric Lépy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show the Sent Memes view if there are saved memes
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var memes = appDelegate.memes
        
        if memes.count > 0 {
            self.navigationController?.performSegueWithIdentifier("towardTabBarControllerSegue", sender: nil)
        }
        
        //Set the parameters
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let image = self.imageView.image {
            topTextField.hidden = false
            bottomTextField.hidden = false
        }
        
        //Set the buttons
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        shareButton.enabled = (self.imageView.image != nil)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var nbrMemes = appDelegate.memes.count
        cancelButton.enabled = nbrMemes > 0
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications () {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow (notification : NSNotification) {
        
        if bottomTextField.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide (notification : NSNotification) {
        if bottomTextField.editing {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight (notification : NSNotification) -> CGFloat {
        if let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                return keyboardSize.CGRectValue().height
        } else {
            return 0.0
        }
    }

    @IBAction func pickAnImageFromLibrary(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.delegate = self
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.navigationController?.performSegueWithIdentifier("towardTabBarControllerSegue", sender: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "TOP" || textField.text == "BOTTOM") {
        textField.text = ""
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func generateMemedImage () -> UIImage {
        
        //Hide toolbar and navbar
        self.toolBar.hidden = true
        self.navigationController?.navigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        self.toolBar.hidden = false
        self.navigationController?.navigationBarHidden = false
        
        return memedImage
    }
    
    func save() {
        var meme = Meme(topText: self.topTextField.text,
                        bottomText: self.bottomTextField.text,
                        image: self.imageView.image!,
                        memedImage: self.generateMemedImage())
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        
        var image : UIImage = generateMemedImage()
        var memeArray = [image]
        
        var activityController = UIActivityViewController(activityItems: memeArray, applicationActivities: nil)
        activityController.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:Array!, error:NSError!) in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
                self.viewWillAppear(false)
            }
        }
        
        presentViewController(activityController, animated: true, completion: nil)
    }

}

