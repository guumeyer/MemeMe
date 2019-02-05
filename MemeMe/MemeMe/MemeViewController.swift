//
//  ViewController.swift
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToKeyboardNotifications()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
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

    private func presentUIImagePickerController(sorceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sorceType
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - UI Style
    func setupTextField(_ textField: UITextField, text: String) {

        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center

        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: 3,
            NSAttributedString.Key.paragraphStyle: titleParagraphStyle
        ]
        textField.autocapitalizationType = .allCharacters
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
    }

    fileprivate func configureUI(topText: String, bottomText: String, image: UIImage? = nil) {
        memeImageView.image = image
        setupTextField(topTextField, text: topText)
        setupTextField(bottomTextField, text: bottomText)
    }

    // MARK: - Keyboard

    @objc func keyboardWillShow(_ notification: Notification) {
        print("keyboardWillShow")
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

    // MARK: - Actions
    @IBAction func shareAction(_ sender: Any) {
        guard let memedImage = generateMemedImage()  else {
            //TODO: show alert view to select a image
            return
        }
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save()
            } else {
                // TODO: call alert error message
            }

            self.dismiss(animated: true, completion: nil)
        }
        self.present(controller, animated: true, completion: nil)
    }

    private func save() {
        // Create the meme
        guard let originalImage = memeImageView.image,
            let memedImage = generateMemedImage()  else {
                Alerts.showAlert(self, Alerts.GenerateMemeFailedTitle, message: Alerts.GenerateMemeFailedMessage)
                return
        }

        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: originalImage, memedImage: memedImage)
    }

    private func generateMemedImage() -> UIImage? {
        // Hide toolbar and navbar
        toolbar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        guard let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() else  {
            return nil
        }

        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        toolbar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        return memedImage
    }

    fileprivate func configureNavBarButtons(isEnable: Bool) {
        shareButton.isEnabled = isEnable
        cancelButton.isEnabled = isEnable
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
