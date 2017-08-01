//
//  SentPhotosLayout.swift
//  Recap
//
//  Created by Alex Brashear on 7/30/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class SentPhotosLayout: UICollectionViewFlowLayout {
    let innerSpace: CGFloat = 1
    let numberOfCellsOnRow: CGFloat = 3
    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width / self.numberOfCellsOnRow) - self.innerSpace
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemWidth())
        }
        get {
            return CGSize(width: itemWidth(), height: (itemWidth() * 0.7).rounded())
        }
    }
}
