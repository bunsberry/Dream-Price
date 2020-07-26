//
//  ProjectsVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

class ProjectsVC: UITableViewController {
    
    var transactionCount = 0
    private let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    // MARK: Navigation Bar Setup
    
    private struct Const {
        static let SettingsSizeForLargeState: CGFloat = 40
        static let SettingsRightMargin: CGFloat = 16
        static let SettingsBottomMarginForLargeState: CGFloat = 12
        static let SettingsBottomMarginForSmallState: CGFloat = 6
        static let SettingsSizeForSmallState: CGFloat = 32
        static let NavBarHeightSmallState: CGFloat = 44
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showImage(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showImage(false)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        
        moveAndResizeImage(for: height)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let settingsButtonImage = UIImage(systemName: "gear")
        settingsButton.setTitle("", for: .normal)
        settingsButton.setImage(settingsButtonImage?.withTintColor(.label, renderingMode:.alwaysOriginal), for: .normal)
        settingsButton.setImage(settingsButtonImage?.withTintColor(.quaternaryLabel, renderingMode:.alwaysOriginal), for: .highlighted)
        settingsButton.contentVerticalAlignment = .fill
        settingsButton.contentHorizontalAlignment = .fill
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(settingsButton)
        settingsButton.clipsToBounds = true
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.SettingsRightMargin),
            settingsButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.SettingsBottomMarginForLargeState),
            settingsButton.heightAnchor.constraint(equalToConstant: Const.SettingsSizeForLargeState),
            settingsButton.widthAnchor.constraint(equalTo: settingsButton.heightAnchor)
        ])
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.SettingsSizeForSmallState / Const.SettingsSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        let sizeDiff = Const.SettingsSizeForLargeState * (1.0 - factor)
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.SettingsBottomMarginForLargeState - Const.SettingsBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.SettingsBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        settingsButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.settingsButton.alpha = show ? 1.0 : 0
        }
    }
    
    @objc func openSettings() {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }
    
    // MARK: Table view setup
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return DataService.actions.count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Base.projectsID, for: indexPath) as! ProjectsCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Base.actionsID, for: indexPath) as! ActionsCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 256.0
        } else {
            return 64.0
        }
    }
}

