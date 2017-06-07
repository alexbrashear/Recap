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
    
    var storedPhoto: Photo? {
        didSet {
            guard let storedPhoto = storedPhoto else { return }
            //statusAccessory.image = UIImage(named: "RCPDarkCheck")
            statusAccessory.image = nil
            status.text = "EXPECTED"
            deliveryDate.text = storedPhoto.expectedDeliveryDate.filmPurchaseDateString
            photo.imageFromUrl(url: storedPhoto.thumbnails.medium)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

extension UIImageView {
    public func imageFromUrl(url: URL) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let test = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = test
            }
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
