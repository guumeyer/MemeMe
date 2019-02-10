//
//  MemeCollectionCollectionViewController.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/5/19.
//  Copyright © 2019 Meyer. All rights reserved.
//
import UIKit

/// Displays the Memes 
final class MemeCollectionCollectionViewController: UICollectionViewController {

    // MARK: - IBOutlet

    @IBOutlet weak  var flowLayout: UICollectionViewFlowLayout!

    // MARK: - Properties

    var memes: [Meme] {
        return Repository.share.memes
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    // MARK: - Action
    @IBAction func createMemeDidToutchUp(_ sender: Any) {
        Coordinator.presentEditMeme(viewController: self)
    }

    // MARK: - UI setup
    /// Setups the collection view
    fileprivate func setupCollectionView() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemeCollectionViewCell.reuseIdentifier, for: indexPath)

        // Set the name and image
        if let memeCell = cell as? MemeCollectionViewCell {
            memeCell.meme = memes[indexPath.row]
        }

        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Coordinator.pushViewerMeme(viewController: self, meme: memes[indexPath.row])
    }
}
