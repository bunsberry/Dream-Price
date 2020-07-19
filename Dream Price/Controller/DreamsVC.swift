//
//  DreamsVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

enum DreamType {
    case focusedDream
    case dream
}

struct Dream {
    let type: DreamType
    let title: String
    let description: String
    let balance: Float?
    let goal: Float
    let dateAdded: Date
}

private func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    dateFormat.locale = Locale.current
    return dateFormat.date(from: str)!
}

var DreamsList: [Dream] = [
    Dream(type: .focusedDream, title: "Поездка на мальдивы", description: "Солнце, пляж... То что надо!", balance: 50000, goal: 150000, dateAdded: parseDate("2020-06-15")),
    Dream(type: .dream, title: "iPhone 11", description: "Монобровь это не так уж и плохо!", balance: nil, goal: 89999, dateAdded: parseDate("2020-06-13")),
    Dream(type: .dream, title: "iPhone 11", description: "Монобровь это не так уж и плохо!", balance: nil, goal: 89999, dateAdded: parseDate("2020-06-13")),
    Dream(type: .dream, title: "iPhone 11", description: "Монобровь это не так уж и плохо!", balance: nil, goal: 89999, dateAdded: parseDate("2020-06-13"))
]


class DreamsVC: UICollectionViewController {
    
    // TODO: Reading from DB

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }
    
    // MARK: Navigation Bar Setup
    
    private var addButton = UIButton()
    
    private struct Const {
        static let AddSizeForLargeState: CGFloat = 40
        static let AddRightMargin: CGFloat = 16
        static let AddBottomMarginForLargeState: CGFloat = 12
        static let AddBottomMarginForSmallState: CGFloat = 6
        static let AddSizeForSmallState: CGFloat = 32
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
        
        title = "Мечты"
        let addButtonImage = UIImage(systemName: "plus.circle")
        addButton.setTitle("", for: .normal)
        addButton.setImage(addButtonImage?.withTintColor(.label, renderingMode:.alwaysOriginal), for: .normal)
        addButton.setImage(addButtonImage?.withTintColor(.quaternaryLabel, renderingMode:.alwaysOriginal), for: .highlighted)
        addButton.contentVerticalAlignment = .fill
        addButton.contentHorizontalAlignment = .fill
        addButton.addTarget(self, action: #selector(addDream), for: .touchUpInside)
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(addButton)
        addButton.clipsToBounds = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.AddRightMargin),
            addButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.AddBottomMarginForLargeState),
            addButton.heightAnchor.constraint(equalToConstant: Const.AddSizeForLargeState),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor)
        ])
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.AddSizeForSmallState / Const.AddSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        let sizeDiff = Const.AddSizeForLargeState * (1.0 - factor)
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.AddBottomMarginForLargeState - Const.AddBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.AddBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        addButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.addButton.alpha = show ? 1.0 : 0
        }
    }
    
    // MARK: Settings Button Action
    
    @objc func addDream(sender: UIButton!) {
        performSegue(withIdentifier: "toAddDream", sender: nil)
    }
    
    // MARK: Collection View Setup
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DreamsList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var currency = Locale.current.currencySymbol
        if Locale.current.currencySymbol == "RUB" { currency = "₽" }
        
        if DreamsList[indexPath.row].type == .focusedDream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "focusedCell", for: indexPath) as! FocusedDreamCell
            
            cell.titleLabel.text = DreamsList[indexPath.row].title
            cell.descriptionLabel.text = DreamsList[indexPath.row].description
            
            // TODO: Formatting balance and date
            
            cell.balanceLabel.text = "\(DreamsList[indexPath.row].balance ?? 0) \(currency ?? "$")"
            cell.goalLabel.text = "\(DreamsList[indexPath.row].goal) \(currency ?? "$")"
            cell.dateLabel.text = ""
            cell.progressView.progress = DreamsList[indexPath.row].balance! / DreamsList[indexPath.row].goal
            
            cell.contentView.backgroundColor = UIColor.systemBackground
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.masksToBounds = true

            cell.layer.shadowColor = UIColor.label.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 8
            cell.layer.shadowOpacity = 0.1
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as! DreamCell
            
            cell.titleLabel.text = DreamsList[indexPath.row].title
            cell.descriptionLabel.text = DreamsList[indexPath.row].description
            cell.priceLabel.text = "\(DreamsList[indexPath.row].goal) \(currency ?? "$")"
            cell.dateLabel.text = ""
            
            cell.contentView.backgroundColor = UIColor.systemBackground
            cell.contentView.layer.cornerRadius = 5
            cell.contentView.layer.masksToBounds = true

            cell.layer.shadowColor = UIColor.label.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
            cell.layer.shadowRadius = 8
            cell.layer.shadowOpacity = 0.1
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected at \(indexPath.row)")
        performSegue(withIdentifier: "toEditDream", sender: nil)
        
        // TODO: Delegate with id and cell data
    }
}
