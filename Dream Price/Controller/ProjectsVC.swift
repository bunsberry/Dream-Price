//
//  ProjectsVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

class ProjectsVC: UITableViewController, ProjectDelegate, CompletedActionDelegate {
    
    var transactionCount = 0
    private let settingsButton = UIButton()
    
    var actions: [Action] = [Action(id: UUID().uuidString, projectID: "", text: "Завершенное действие", isCompleted: true, dateCompleted: Date()),
                             Action(id: UUID().uuidString, projectID: "", text: "Завершенное действие", isCompleted: true, dateCompleted: Date()),
                             Action(id: UUID().uuidString, projectID: "", text: "Незавершенное действие", isCompleted: false, dateCompleted: nil)]
    var completedActions: [Action] = []
    var chosenProjectID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        
        for action in actions {
            if action.isCompleted {
                completedActions.append(action)
            }
        }
        
        // TODO: Add completed projects
        completedActions.sort(by: { $0.dateCompleted! > $1.dateCompleted! })
    }
    
    func newProject() {
        chosenProjectID = "new"
        performSegue(withIdentifier: "toProject", sender: nil)
    }
    
    func openProject(id: String) {
        chosenProjectID = id
        performSegue(withIdentifier: "toProject", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // todo: db
        if segue.identifier == "toProject" && chosenProjectID != "new" {
            let vc = segue.destination as! ProjectVC
            
            vc.projectID = chosenProjectID
            vc.isNewProject = false
        } else if segue.identifier == "toProject" && chosenProjectID == "new" {
            let vc = segue.destination as! ProjectVC
            
            // creating new project object
            vc.projectID = UUID().uuidString
            vc.isNewProject = true
        }
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
        tableView.allowsSelection = false
        
        if section == 0 || section == 1 {
            return 1
        } else {
            // recent actions count
            if completedActions.count != 0 {
                return completedActions.count
            } else {
                return 1
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsCell", for: indexPath) as! ProjectsCell
            cell.delegate = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeparatorCell", for: indexPath)
            return cell
        } else {
            if completedActions.count != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "completedActionCell", for: indexPath) as! CompletedActionCell
                
                cell.textTextView.text = completedActions[indexPath.row].text
                cell.completitionButton.isSelected = true
                cell.actionID = completedActions[indexPath.row].id
                cell.delegate = self
                
                tableView.beginUpdates()
                tableView.endUpdates()
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NoActionsCell", for: indexPath)
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 256.0
        } else if indexPath.section == 1 {
            return 28.0
        } else {
            if completedActions.count == 0 {
                return 64
            } else {
                return UITableView.automaticDimension
            }
        }
    }
    
    func removedCompletition(id: String) {
        for (index, action) in completedActions.enumerated() {
            if action.id == id {
                completedActions.remove(at: index)
                // realm delete object
                if completedActions.count == 0 {
                    tableView.reloadRows(at: [IndexPath(row: index, section: 2)], with: .automatic)
                } else {
                    tableView.deleteRows(at: [IndexPath(row: index, section: 2)], with: .automatic)
                }
            }
        }
    }
}

