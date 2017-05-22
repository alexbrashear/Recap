//
//  RootFlowCoordinator+SentPhotos.swift
//  Recap
//
//  Created by Alex Brashear on 5/18/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

extension RootFlowCoordinator {
    func pushSentPhotosController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.usedFilmList.usedFilmListController() else { return }
        configureUsedFilmListController(vc)
        configureUsedFilmNavBar(nc: nc)
        nc.pushViewController(vc, animated: true)
        nc.setNavigationBarHidden(false, animated: false)
    }
    
    private func configureUsedFilmNavBar(nc: UINavigationController) {
        nc.navigationBar.barTintColor = .rcpAzure
        nc.navigationBar.tintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20)]
        
    }
    
    private func configureUsedFilmListController(_ vc: UsedFilmListController) {
        vc.title = "History"
    }
}
