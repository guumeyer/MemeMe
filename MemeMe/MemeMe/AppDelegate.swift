//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/3/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    var memes = [Meme]()

    // MARK: - UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let monkey = UIImage(named: "monkey")
        let meme = Meme(topText: "top",
                        bottomText: "bottom Text",
                        originalImage: monkey!,
                        memedImage: monkey!)

        let meme2 = Meme(topText: "top 2",
                        bottomText: "bottom Text 2",
                        originalImage: monkey!,
                        memedImage: monkey!)

        memes.append(meme)
        memes.append(meme2)

        return true
    }
}

