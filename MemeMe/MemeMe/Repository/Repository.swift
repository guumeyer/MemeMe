//
//  MemeRepository.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/9/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import Foundation

/// Represents a single repository
final class Repository {

    // MARK: - Properties

    // Meme record set
    var memes: [Meme]

    // Share instance of Repository
    static let share = Repository()

    private init() {
        memes = [Meme]()
    }
}
