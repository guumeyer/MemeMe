//
//  DetailMemeViewController.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/8/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

final class DetailMemeViewController: UIViewController {

    // MARK: - Properties
    var meme: Meme!

    // MARK: - Outlets
    @IBOutlet weak var memeImageView: UIImageView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addEditButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.image = meme.memedImage

        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK: - UI Setup
    fileprivate func addEditButton() {
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editDidTouchUpInside))
        navigationItem.rightBarButtonItem  = editBarButtonItem
    }

    // MARK: - Actions
    @objc func editDidTouchUpInside() {

        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.navigationController!.popToRootViewController(animated: false)
        })
        Coordinator.presentEditMeme(viewController: self, meme: self.meme)
        CATransaction.commit()

    }
}
