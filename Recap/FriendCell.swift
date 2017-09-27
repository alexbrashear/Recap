//
//  FriendCell.swift
//  Recap
//
//  Created by Alex Brashear on 9/11/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable
import Iconic

class FriendCell: UITableViewCell, NibReusable {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    
    struct ViewModel {
        let name: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            name.text = viewModel?.name
        }
    }
    
    let unselectedIcon = FontAwesomeIcon._446Icon
    let selectedIcon = FontAwesomeIcon.okSignIcon
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.font = UIFont.openSansFont(ofSize: 16)
        selectionStyle = .none
        loadIcon(selected: isSelected)
    }
    
    private func loadIcon(selected: Bool) {
        let icon = selected ? selectedIcon : unselectedIcon
        let image = icon.image(ofSize: CGSize(width: 20, height: 20), color: .rcpClearBlue)
        self.icon.image = image
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        loadIcon(selected: selected)
    }
}
