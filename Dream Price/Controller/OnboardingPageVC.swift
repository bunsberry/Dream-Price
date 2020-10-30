//
//  OnboardingPageVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 22.09.2020.
//

import UIKit

class OnboardingPageVC: UIViewController {

    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headlineLabel.text = NSLocalizedString("WelcomeTitle", comment: "")
        descriptionLabel.text = NSLocalizedString("WelcomeText", comment: "")
        dismissButton.setTitle(NSLocalizedString("WelcomeButton", comment: ""), for: .normal)
    }
    
    @IBAction func dimsissOnboarding() {
        dismiss(animated: true, completion: nil)
    }
}
