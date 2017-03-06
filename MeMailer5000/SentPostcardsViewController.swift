//
//  SentPostcardsViewController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/26/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

struct SentPostcardCellConfiguration {
    let name: String
    let expectedDelivery: String
    let thumbnailURL: URL
}

protocol SentPostcardsViewModelProtocol: class {
    var numberOfSections: Int { get }
    
    func numberOfRows(in section: Int) -> Int
    
    func cellConfiguration(for indexPath: IndexPath) -> SentPostcardCellConfiguration
}

typealias ImageFetchCompletion = (UIImage?) -> Void

protocol ImageProviderProtocol: class {
    func hasItemInCache(itemURL: URL) -> Bool
    
    func cachedImage(for url: URL) -> UIImage?
    
    func fetchImage(for url: URL, completion: @escaping ImageFetchCompletion)
}

class SentPostcardsViewController: UITableViewController {
    
    fileprivate var viewModel: SentPostcardsViewModelProtocol = SentPostcardsViewModel(sentPostcards: [])
    
    fileprivate let imageProvider: ImageProviderProtocol = ImageProvider()

    let databaseConnection = DatabaseController.sharedInstance.newWritingConnection()
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Postcards", comment: "The title for the page listing the postcards sent by the user")
        readData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(yapDatabaseModified), name: NSNotification.Name.YapDatabaseModified, object: DatabaseController.sharedInstance.yapDatabase)
        
        let nib = UINib(nibName: String(describing: SentPostcardCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: SentPostcardCell.self))
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
    }
    
    func yapDatabaseModified(notification: Notification) {
        readData()
        tableView.reloadData()
    }
    
    func readData() {
        databaseConnection.beginLongLivedReadTransaction()
        var postcards: [Postcard]?
        databaseConnection.read { transaction in
            postcards = transaction.object(forKey: "postcards", inCollection: "postcards") as? [Postcard]
        }
        if let postcards = postcards {
            viewModel = SentPostcardsViewModel(sentPostcards: postcards)
        }
    }
}

/// UITableViewDataSource

extension SentPostcardsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SentPostcardCell.self)) as? SentPostcardCell else {
            return UITableViewCell()
        }
        
        let configuration = viewModel.cellConfiguration(for: indexPath)
        var image: UIImage?
        if imageProvider.hasItemInCache(itemURL: configuration.thumbnailURL) {
            image = imageProvider.cachedImage(for: configuration.thumbnailURL)
        } else {
            imageProvider.fetchImage(for: configuration.thumbnailURL) { [weak self] image in
                DispatchQueue.main.async {
                    self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        cell.viewModel = SentPostcardCell.ViewModel(name: configuration.name, expectedDelivery: configuration.expectedDelivery, postcardThumbnail: image)
        return cell
    }
}
