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
        case inviteCode
        
        var key: String {
            switch self {
            case .welcomeFlow:
                return "hasShownWelcomeFlow"
            case .inviteCode:
                return "hasShownInviteCode"
            }
        }
    }
    
    func shouldShow(onboarding: OnboardingKind) -> Bool {
        let hasShownOnboarding = defaults.bool(forKey: onboarding.key)
        return !hasShownOnboarding
    }
    
    func complete(onboarding: OnboardingKind) {
        defaults.set(true, forKey: onboarding.key)
    }
}
