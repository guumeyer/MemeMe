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
    @IBOutlet weak var memLabel: UILabel!
    @IBOutlet weak var memeImageView: UIImageView!

    static let reuseIdentifier = "MemeCell"

    var meme: Meme! {
        didSet {
            memLabel?.text = "\(meme.topText.uppercased())...\(meme.bottomText.uppercased())"
            memeImageView?.image = meme.memedImage
        }
    }
}
