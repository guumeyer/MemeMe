//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Meyer, Gustavo on 2/5/19.
//  Copyright © 2019 Meyer. All rights reserved.
//

import UIKit

/// Displays the Memes
final class MemeTableViewController: UITableViewController {

    // MARK: - Properties

    var memes: [Meme] {
        return Repository.share.memes
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if memes.isEmpty {
            Coordinator.presentEditMeme(viewController: self, animated: false)
        }

        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Actions

    @IBAction func createMemeDidToutchUp(_ sender: Any) {
        print("createMemeDidToutchUp ?")
        Coordinator.presentEditMeme(viewController: self)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemeTableViewCell.reuseIdentifier, for: indexPath)

        if let memeCell = cell as? MemeTableViewCell {
            memeCell.meme = memes[indexPath.row]
        }

        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            Repository.share.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        Coordinator.pushViewerMeme(viewController: self, animated: true, meme: meme)
    }

}
