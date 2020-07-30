//
//  DreamsVC.swift
//  Dream Price
//
//  Created by Noisegain on 14.07.2020.
//

import UIKit

enum DreamType {
    case focusedDream
    case dream
}

struct Dream {
    var dreamID: String
    var type: DreamType
    var title: String
    var description: String
    var balance: Float
    var goal: Float
    var dateAdded: Date
}

var dreamsList: [Dream] = [
    Dream(dreamID: UUID().uuidString, type: .focusedDream, title: NSLocalizedString("Trip to London", comment: ""), description: NSLocalizedString("I wanna see Big Ben", comment: ""), balance: 50000, goal: 150000, dateAdded: parseDate("2020-06-15")),
    Dream(dreamID: UUID().uuidString, type: .dream, title: NSLocalizedString("New Phone", comment: ""), description: NSLocalizedString("Mine's a bit old now...", comment: ""), balance: 0, goal: 89999, dateAdded: parseDate("2020-06-13"))
]


class DreamsVC: UICollectionViewController {
    
    // TODO: Reading from DB

    @IBOutlet public var dreamCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.dreamCollection.reloadData()
        }
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
        
        title = NSLocalizedString("DreamsTitle", comment: "")
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
    
    // MARK: Add Dream Button Action
    
    @objc func addDream(sender: UIButton!) {
        performSegue(withIdentifier: "toAddDream", sender: nil)
        AddDreamsVC.delegate = self
    }
    
    // MARK: Collection View Setup
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dreamsList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currencyFormatter = NumberFormatter()
        
        if let localeIdentifier = Settings.shared.chosenLocaleIdentifier {
            currencyFormatter.locale = Locale.init(identifier: localeIdentifier)
        } else {
            currencyFormatter.locale = Locale.current
            if Locale.current.currencyCode == "RUB" {
                currencyFormatter.locale = Locale.init(identifier: "ru_RU")
            }
        }
        
        currencyFormatter.numberStyle = .currency
        
        if Settings.shared.recordCentsOn! {
            currencyFormatter.minimumFractionDigits = 2
            currencyFormatter.maximumFractionDigits = 2
        } else {
            currencyFormatter.minimumFractionDigits = 0
            currencyFormatter.maximumFractionDigits = 0
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = Locale.current.calendar
        
        if currencyFormatter.locale.currencyCode == "RUB" {
            dateFormatter.locale = Locale.init(identifier: "ru_RU")
        }
        
        if dreamsList[indexPath.row].type == .focusedDream {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "focusedCell", for: indexPath) as! FocusedDreamCell
            
            cell.backgroundColor = .clear
            cell.titleLabel.text = dreamsList[indexPath.row].title
            cell.descriptionLabel.text = dreamsList[indexPath.row].description
            
            cell.dateLabel.text = dateFormatter.string(from: dreamsList[indexPath.row].dateAdded)
            cell.balanceLabel.text = "\(currencyFormatter.string(from: NSNumber(value: dreamsList[indexPath.row].balance)) ?? "0")"
            cell.goalLabel.text = "\(currencyFormatter.string(from: NSNumber(value: dreamsList[indexPath.row].goal)) ?? "0")"
            
            cell.progressView.progress = dreamsList[indexPath.row].balance / dreamsList[indexPath.row].goal
            
            cell.contentView.layer.cornerRadius = 10
            
            let gradient: CAGradientLayer = CAGradientLayer()
            
            gradient.colors = [UIColor(red: 0.506, green: 0.616, blue: 0.898, alpha: 1).cgColor, UIColor(red: 0.443, green: 0.541, blue: 0.792, alpha: 1).cgColor]
            gradient.cornerRadius = 10
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.6, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.4, y: 1.0)
            gradient.frame = CGRect(x: 0.0,
                                    y: 0.0,
                                    width: cell.frame.size.width,
                                    height: cell.frame.size.height)

            cell.layer.insertSublayer(gradient, at: 0)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dreamCell", for: indexPath) as! DreamCell
            
            cell.backgroundColor = .clear
            cell.titleLabel.text = dreamsList[indexPath.row].title
            cell.descriptionLabel.text = dreamsList[indexPath.row].description
            
            cell.dateLabel.text = dateFormatter.string(from: dreamsList[indexPath.row].dateAdded)
            cell.priceLabel.text = "\(currencyFormatter.string(from: NSNumber(value: dreamsList[indexPath.row].goal)) ?? "0")"
            
            cell.contentView.layer.cornerRadius = 10
            
            let gradient: CAGradientLayer = CAGradientLayer()
            
            gradient.colors = [UIColor(red: 0.506, green: 0.616, blue: 0.898, alpha: 1).cgColor, UIColor(red: 0.443, green: 0.541, blue: 0.792, alpha: 1).cgColor]
            gradient.cornerRadius = 10
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.6, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.4, y: 1.0)
            gradient.frame = CGRect(x: 0.0,
                                    y: 0.0,
                                    width: cell.frame.size.width,
                                    height: cell.frame.size.height)

            cell.layer.insertSublayer(gradient, at: 0)
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected at \(indexPath.row)")
        selectedDreamToEdit = indexPath.row
        performSegue(withIdentifier: "toEditDream", sender: nil)
        EditDreamsVC.delegate = self
        EditDreamsVC.dreamID = dreamsList[indexPath.row].dreamID
    }
}

extension DreamsVC: AddDreamDelegate, EditDreamDelegate {
    func dreamAdded(newDream: Dream) {
        
        // TODO: DB dream add
        
        var newDream = newDream
        
        if newDream.type == .focusedDream {
            newDream.balance = dreamsList[0].balance
            dreamsList[0].balance = 0
            dreamsList[0].type = .dream
            dreamsList.insert(newDream, at: 0)
        } else {
            dreamsList.append(newDream)
        }
        
        dreamCollection.reloadData()
    }
    
    func dreamDeleted(dreamID: String, row: Int) {
        
        // TODO: Delete from DB by ID
        
        dreamsList.remove(at: row)
        dreamCollection.reloadData()
        
    }
    
    func dreamEdited(dream: Dream, row: Int) {
    
        // TODO: DB dream edit
        
        var dream = dream
        
        if dream.type == .focusedDream && row == 0 {
            dreamsList[0].title = dream.title
            dreamsList[0].description = dream.description
            dreamsList[0].goal = dream.goal
        } else if dream.type == .focusedDream {
            dream.balance = dreamsList[0].balance
            dreamsList[0].balance = 0
            dreamsList[0].type = .dream
            dreamsList.remove(at: row)
            dreamsList.insert(dream, at: 0)
        } else if row == 0 && dream.type == .dream {
            dreamsList[0].title = dream.title
            dreamsList[0].description = dream.description
            dreamsList[0].goal = dream.goal
            dreamsList[0].type = .dream
        } else {
            dreamsList[row].title = dream.title
            dreamsList[row].description = dream.description
            dreamsList[row].goal = dream.goal
        }
        
        dreamCollection.reloadData()
        
    }
}
