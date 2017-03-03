//
//  PostcardsViewController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/26/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class PostcardsViewController: UITableViewController {

    override func viewDidLoad() {
        title = NSLocalizedString("Postcards", comment: "The title for the page listing the postcards sent by the user")
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
