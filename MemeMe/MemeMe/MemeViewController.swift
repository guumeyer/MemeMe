//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/3/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

final class MemeViewController: UIViewController,
UINavigationControllerDelegate {

    // MARK: IBOutlet

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeImageView: UIImageView!
    // Toolbar
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    // Navbar
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    // MARK: Properties
    private let topDefaultValue = "TOP"
    private let bottomDefaultValue = "BOTTOM"
    private var shouldMoveFrameOriginY: Bool = false

    // MARK: - Life cycle

    override func viewDidLoad() {

        super.viewDidLoad()

        configureUI(topText: topDefaultValue, bottomText: bottomDefaultValue)

        configureNavBarButtons(isEnable: false)
        
        // Hide the keyboard when tap the memeImageView
        setupUITapGestureRecognizer(view: memeImageView, action: #selector(handleMemeImageViewTap(sender:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - IBAction

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentUIImagePickerController(sorceType: .photoLibrary)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentUIImagePickerController(sorceType: .camera)
    }

    @IBAction func cancelAction(_ sender: Any) {
        configureUI(topText: topDefaultValue, bottomText: bottomDefaultValue)
        configureNavBarButtons(isEnable: false)
    }

    @IBAction func shareAction(_ sender: Any) {
        guard let memedImage = generateMemedImage()  else {
            Alerts.showAlert(self, Alerts.GenerateMemeFailedTitle, message: Alerts.GenerateMemeFailedMessage)
            return
        }
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { [save] activity, success, items, error in
            if success {
                save()
            } else {
                Alerts.showAlert(self, Alerts.GenerateMemeFailedTitle, message: String(describing: error))
            }

            self.dismiss(animated: true, completion: nil)
        }
        self.present(controller, animated: true, completion: nil)
    }

    // MARK: - UI Style

    /// Defines the common text style for UITextField
    ///
    /// - parameters: textField - The `UITextField` will be defined the text style
    /// - parameters: text - The text value will be formatted
    private func setupTextField(_ textField: UITextField, text: String) {

        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center

        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.paragraphStyle: titleParagraphStyle
        ]
        textField.autocapitalizationType = .allCharacters
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
    }

    /// Configure the Meme UI componets
    ///
    /// - parameters: topText - The text value for `topTextField`.
    /// - parameters: bottomText - The text value for `bottomTextField`.
    /// - parameters: image - The image to set to the `memeImageView.image`.
    private func configureUI(topText: String, bottomText: String, image: UIImage? = nil) {
        memeImageView.image = image
        setupTextField(topTextField, text: topText)
        setupTextField(bottomTextField, text: bottomText)
    }

    /// Presents the UIImagePickerController modal view
    ///
    /// - parameters: The `UIImagePickerController.SourceType` option
    private func presentUIImagePickerController(sorceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sorceType
        present(imagePicker, animated: true, completion: nil)
    }

    /// Configures the Navigation bar buttons
    ///
    /// - parameters: isEnable - Defines the buttons are enabled
    private func configureNavBarButtons(isEnable: Bool) {
        shareButton.isEnabled = isEnable
        cancelButton.isEnabled = isEnable
    }

    /// Hidden the navigation bar and tool bar
    ///
    /// - parameters: isHidden - Defines the Navigation bar and Tool bar are hidden
    private func configuraToolBarAndNavBar(isHidden: Bool) {
        toolbar.isHidden = isHidden
        navigationController?.isNavigationBarHidden = isHidden
    }

    // MARK: - Keyboard

    @objc func keyboardWillShow(_ notification: Notification) {
        if shouldMoveFrameOriginY {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if shouldMoveFrameOriginY {
            view.frame.origin.y = 0
        }
    }

    /// Returns the keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {

        guard let userInfo = notification.userInfo,
            let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return 0
        }

        return keyboardSize.cgRectValue.height
    }
    
    private func setupUITapGestureRecognizer(view: UIView, action: Selector ) {
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }

    @objc func handleMemeImageViewTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // MARK: - Notification Center

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    /// Saves the meme object to be editable
    private func save() {
        // Create the meme
        guard let originalImage = memeImageView.image,
            let memedImage = generateMemedImage()  else {
                Alerts.showAlert(self, Alerts.GenerateMemeFailedTitle, message: Alerts.GenerateMemeFailedMessage)
                return
        }

        let meme = Meme(topText: topTextField.text!,
                        bottomText: bottomTextField.text!,
                        originalImage: originalImage,
                        memedImage: memedImage)

        dump(meme)
    }

    /// Generates the meme image
    ///
    /// - returns: The meme image
    private func generateMemedImage() -> UIImage? {

        // Hide toolbar and navbar
        configuraToolBarAndNavBar(isHidden: true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        guard let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() else  {
            return nil
        }

        UIGraphicsEndImageContext()
        // Show toolbar and navbar
        configuraToolBarAndNavBar(isHidden: false)

        return memedImage
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MemeViewController:  UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            configureNavBarButtons(isEnable: true)
            configureUI(topText: topDefaultValue, bottomText: bottomDefaultValue, image: image)
        }
        dismiss(animated: true, completion: nil)
    }
}
// MARK: UITextFieldDelegate
extension MemeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        shouldMoveFrameOriginY = textField == bottomTextField
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
