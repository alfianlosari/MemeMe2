//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Alfian Losari on 17/08/17.
//  Copyright © 2017 Alfian Losari. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController {
    
    let defaultTopTextFieldText = "TOP"
    let defaultBottomTextFieldText = "BOTTOM"
    let memeTextAttributes: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: Float(-4.0)
    ]
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    var editMeme: Meme?
    weak var memeDetailViewController: MemeDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAttributes(forTextField: topTextField, initialText: defaultTopTextFieldText)
        setupAttributes(forTextField: bottomTextField, initialText: defaultBottomTextFieldText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViewForEditMeme()
        setupShareBarButtonItem()
        cameraBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotification()
    }
    
    func setupViewForEditMeme() {
        guard let meme = editMeme else { return }
        memeImageView.image = meme.originalImage
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    func setupShareBarButtonItem() {
        shareBarButtonItem.isEnabled = memeImageView.image != nil
    }
    
    func setupAttributes(forTextField textField: UITextField, initialText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = initialText
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        guard bottomTextField.isFirstResponder else { return }
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func pickAnImageForAlbum(_ sender: Any) {
        presentImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageForCamera(_ sender: Any) {
        presentImagePicker(sourceType: .camera)
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            guard let topText = self.topTextField.text,
                let bottomText = self.bottomTextField.text,
                let originalImage = self.memeImageView.image
            else { return }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let meme = Meme(topText: topText, bottomText: bottomText, originalImage: originalImage, memedImage: memedImage)
            if let editMeme = self.editMeme {
                guard let index = appDelegate.memes.index(where: { $0 == editMeme }) else { return }
                appDelegate.memes[index] = meme
                self.memeDetailViewController?.meme = meme
            } else {
                appDelegate.memes.append(meme)
            }
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }
        present(activityViewController, animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        hideNavigationBarAndToolbar(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideNavigationBarAndToolbar(false)
        
        return memedImage
    }
    
    func hideNavigationBarAndToolbar(_ isHide: Bool) {
        navigationBar.isHidden = isHide
        toolbar.isHidden = isHide
    }

    override var prefersStatusBarHidden: Bool { return true }
}

extension MemeEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            setupShareBarButtonItem()
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


extension MemeEditViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if textField === topTextField && text == defaultTopTextFieldText {
            textField.text = ""
        } else if textField === bottomTextField && text == defaultBottomTextFieldText {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
