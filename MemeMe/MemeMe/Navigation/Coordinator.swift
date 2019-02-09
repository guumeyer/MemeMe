//
//  Coordinator.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/7/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

/// Coordinate the UI Navigation
struct Coordinator {

    /// Represents the ViewController Identifier defined on Storyboard
    enum ViewIdentifier: String {
        case edit = "editMeme"
        case viewer = "viewerMeme"
    }

    /// Preesent Edit Meme View Controller
    static func presentEditMeme(viewController: UIViewController, animated: Bool = true, meme: Meme? = nil) {
        if let editMemeNavigationController = loadViewController(identifier: .edit) as? UINavigationController, let editMemeController =  editMemeNavigationController.viewControllers.first as? MemeViewController {
            editMemeController.meme = meme
            viewController.present(editMemeNavigationController, animated: animated, completion: nil)
        }
    }

    /// Push Edit Meme View Controller
    static func pushViewerMeme(viewController: UIViewController, animated: Bool = true, meme: Meme) {
        if let editMemeController = loadViewController(identifier: .viewer) as? MemeViewerViewController {
            editMemeController.meme = meme
            viewController.navigationController?.pushViewController(editMemeController, animated: animated)
        }
    }

    /// Retrives the UIViewController by Main.Storyboard by identifier
    private static func loadViewController(identifier: ViewIdentifier) -> UIViewController {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return mainStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}
