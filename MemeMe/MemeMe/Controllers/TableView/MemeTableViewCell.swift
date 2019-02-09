//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/7/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

final class MemeTableViewCell: UITableViewCell {

    // MARK: Properties

    static let reuseIdentifier = "MemeCell"

    var meme: Meme! {
        didSet {
            textLabel?.text = "\(meme.topText.uppercased())...\(meme.bottomText.uppercased())"
            imageView?.image = meme.memedImage
        }
    }
}
