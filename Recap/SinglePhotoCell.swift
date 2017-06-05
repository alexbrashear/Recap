//
//  SinglePhotoCell.swift
//  Recap
//
//  Created by Alex Brashear on 5/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class SinglePhotoCell: UITableViewCell, NibReusable {
    @IBOutlet private var photo: UIImageView!
    @IBOutlet private var statusAccessory: UIImageView!
    @IBOutlet private var status: UILabel!
    @IBOutlet private var deliveryDate: UILabel!
    
    struct ViewModel {
        let photoURL: URL
        let statusAccessory: UIImage
        let status: String
        let deliveryDate: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            statusAccessory.image = viewModel?.statusAccessory
            status.text = viewModel?.status
            deliveryDate.text = viewModel?.deliveryDate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.image = UIColor.rcpBlueyGrey.singlePixelImage()
    }
}

extension UIImageView {
    public func imageFromUrl(url: URL) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            self.image = UIImage(data: data)
        }.resume()
    }
}

/// An extension to simplify creating images from colors
extension UIColor {
    /// Creates a single pixel image from the color
    ///
    /// - Returns: A single pixel `UIImage` of the color
    func singlePixelImage() -> UIImage? {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        set()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
