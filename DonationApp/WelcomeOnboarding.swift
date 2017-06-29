//
//  WelcomeOnboarding.swift
//  DonationApp
//
//  Created by Alex Lee on 2017-06-27.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

class WelcomeOnboardingViewController: UIViewController {
    
    
    @IBOutlet var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureOnboarding()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configureOnboarding() {
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
        
        view.bringSubview(toFront: skipButton)
    }
        
}

// MARK: PaperOnboardingDelegate
extension WelcomeOnboardingViewController: PaperOnboardingDelegate {

//    func onboardingWillTransitonToIndex(_ index: Int) {
//        skipButton.isHidden = index >= 1 ? false : false
//    }
//    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        //    item.titleLabel?.backgroundColor = .redColor()
        //    item.descriptionLabel?.backgroundColor = .redColor()
        //    item.imageView = ...
    }
    
}

// MARK: PaperOnboardingDataSource
extension WelcomeOnboardingViewController: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let titleFont = UIFont(name: "Nunito-Bold", size: 36.0) ?? UIFont.boldSystemFont(ofSize: 36.0)
        let descriptionFont = UIFont(name: "OpenSans-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        let image = UIImage(named: "placeholder")
        return [
            (image!,
             "App name here",
             "Post items you don't want/need anymore, and give other items a new home",
             image!,
             UIColor(red:0.40, green:0.56, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (image!,
             "Posting items",
             "(description here, and screenshot above)",
             image!,
             UIColor(red:0.40, green:0.69, blue:0.71, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont),
            
            (image!,
             "Searching for items",
             "(description here, and screenshot above)",
             image!,
             UIColor(red:0.61, green:0.56, blue:0.74, alpha:1.00),
             UIColor.white, UIColor.white, titleFont,descriptionFont)
            
            ][index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
}
