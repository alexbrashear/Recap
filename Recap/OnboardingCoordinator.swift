//
//  OnboardingCoordinator.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class OnboardingCoordinator {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    enum OnboardingKind {
        case welcomeFlow
        
        var key: String {
            switch self {
            case .welcomeFlow:
                return "hasShownWelcomeFlow"
            }
        }
    }
    
    func shouldShow(onboarding: OnboardingKind) -> Bool {
        let hasShownOnboarding = defaults.bool(forKey: onboarding.key)
        if !hasShownOnboarding {
            defaults.set(true, forKey: onboarding.key)
        }
        return !hasShownOnboarding
    }
}
