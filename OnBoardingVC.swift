//
//  OnBoardingVC.swift
//  GradutionThesis
//
//  Created by Buğra Tunçer on 21.02.2020.
//  Copyright © 2020 Buğra Tunçer. All rights reserved.
//

import UIKit
import paper_onboarding


class OnBoardingVC: UIViewController ,PaperOnboardingDataSource,PaperOnboardingDelegate{
    
    @IBOutlet weak var skipButton: UIButton!
    fileprivate let items = [
        
        OnboardingItemInfo(informationImage: UIImage(named: "brush")!,
                           title: "WELCOME TO OUR FOOD APP",
                           description: "You Can Order A HOME FOOD !",
                           pageIcon: UIImage(named: "brush")!,
                           color: UIColor.systemIndigo,
                           titleColor: UIColor.systemGray,
                           descriptionColor: UIColor.systemGray2,
                           titleFont: UIFont.boldSystemFont(ofSize: 30),
                           descriptionFont: UIFont.boldSystemFont(ofSize: 15)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "notification")!,
                           title: "WHAT WOULD YOU LIKE TO EAT?",
                           description: "HOME FOOD!",
                           pageIcon: UIImage(named: "brush")!,
                           color: UIColor.systemBlue,
                           titleColor: UIColor.systemGray,
                           descriptionColor: UIColor.systemGray2,
                           titleFont: UIFont.boldSystemFont(ofSize: 30),
                           descriptionFont: UIFont.boldSystemFont(ofSize: 15)),
        OnboardingItemInfo(informationImage: UIImage(named: "rocket")!,
                           title: "THANK YOU FOR USING APP",
                           description: "LET'S GO",
                           pageIcon: UIImage(named: "brush")!,
                           color: UIColor.systemRed,
                           titleColor: UIColor.systemGray,
                           descriptionColor: UIColor.systemGray2,
                           titleFont: UIFont.boldSystemFont(ofSize: 30),
                           descriptionFont: UIFont.boldSystemFont(ofSize: 15))
    ]
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    func onboardingWillTransitonToIndex(_ index: Int) {
        skipButton.isHidden = index == 2 ? false : true
    }
    
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        skipButton.isHidden = true
        setupPaperOnboardingView()
        view.bringSubviewToFront(skipButton)
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

