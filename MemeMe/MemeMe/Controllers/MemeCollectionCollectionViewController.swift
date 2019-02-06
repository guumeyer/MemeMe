//
//  MemeCollectionCollectionViewController.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/5/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit


/// Displays the Memes 
class MemeCollectionCollectionViewController: UICollectionViewController {

    // MARK: - IBOutlet

    @IBOutlet weak  var flowLayout: UICollectionViewFlowLayout!

    // MARK: - Properties

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: MemeCollectionViewCell.reuseIdentifier)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

        // Grab the DetailVC from Storyboard
//        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "VillainDetailViewController") as! VillainDetailViewController
//
//        //Populate view controller with data from the selected item
//        detailController.villain = allVillains[(indexPath as NSIndexPath).row]
//
//        // Present the view controller using navigation
//        navigationController!.pushViewController(detailController, animated: true)
    }



}
