//
//  OnboardingPVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 22.09.2020.
//

import UIKit

class OnboardingPVC: UIPageViewController {

    let pagesData: [PageStruct] = [
        PageStruct(imageName: "IconClassic", headlineText: NSLocalizedString("WelcomeTitle", comment: ""), descriptionText: NSLocalizedString("WelcomeText", comment: "")),
        PageStruct(imageName: "budgetPage", headlineText: NSLocalizedString("BudgetTitle", comment: ""), descriptionText: NSLocalizedString("BudgetText", comment: "")),
        PageStruct(imageName: "dreamsPage", headlineText: NSLocalizedString("DreamsTitle", comment: ""), descriptionText: NSLocalizedString("DreamsText", comment: "")),
        PageStruct(imageName: "projectsPage", headlineText: NSLocalizedString("ProjectsTitle", comment: ""), descriptionText: NSLocalizedString("ProjectsText", comment: ""))
    ]
    
    var currentIndex: Int = 0
    
    var appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.secondarySystemGroupedBackground
        
        appearance.pageIndicatorTintColor = UIColor.secondaryLabel
        appearance.currentPageIndicatorTintColor = UIColor.label

        self.dataSource = self
        self.delegate = self
        
        if let vc = self.pageViewController(for: 0) {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(for index: Int) -> OnboardingPageVC? {
        if index < 0 || index >= pagesData.count {
            return nil
        }
        let vc = (storyboard?.instantiateViewController(withIdentifier: "DataViewController") as! OnboardingPageVC)
        
        vc.headlineLabelText = pagesData[index].headlineText
        vc.descriptionLabelText = pagesData[index].descriptionText
        vc.emojiImage = UIImage(named: pagesData[index].imageName)
        vc.index = index
        self.currentIndex = index
        
        return vc
    }

}

extension OnboardingPVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pagesData.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? OnboardingPageVC)?.index ?? 0) - 1
        
        return self.pageViewController(for: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = ((viewController as? OnboardingPageVC)?.index ?? 0) + 1
        
        return self.pageViewController(for: index)
    }
    
}

