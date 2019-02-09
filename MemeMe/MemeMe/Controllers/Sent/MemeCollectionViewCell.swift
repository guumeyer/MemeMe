//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/6/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

/// Represents the meme collection view cell
final class MemeCollectionViewCell: UICollectionViewCell {

    // MARK: IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: Properties

    static let reuseIdentifier = "MemeCollectionViewCell"

    var meme: Meme! {
        didSet {
            imageView.image = meme.memedImage
        }
    }
}
