//
//  HistoryVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 17.07.2020.
//

import UIKit

struct Transaction {
    var date : Date
    var number : Float
    var category : String
}

enum SortingType {
    case daily
    case monthly
}

// TODO: Добавить перевод даты в русский язык (locale тупит чет)

private func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)!
}

private func dayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.month, .day], from: date)
    return calendar.date(from: components)!
}

private func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "yyyy-MM-dd"
    dateFormat.locale = Locale.current
    return dateFormat.date(from: str)!
}

class HistoryVC: UITableViewController {
    
    private let sortButton = UIButton()
    private var sortedBy: SortingType = .daily {
        didSet { tableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        setupNavBar()
        
        transactions.sort { $0.date > $1.date }
        generateSections()
    }
    
    // MARK: Navigation Bar Setup
    
    private struct Const {
        static let SortSizeForLargeState: CGFloat = 40
        static let SortRightMargin: CGFloat = 16
        static let SortBottomMarginForLargeState: CGFloat = 12
        static let SortBottomMarginForSmallState: CGFloat = 6
        static let SortSizeForSmallState: CGFloat = 32
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
        
        title = "История"
        let sortButtonImage = UIImage(systemName: "line.horizontal.3.decrease.circle")
        sortButton.setTitle("", for: .normal)
        sortButton.setImage(sortButtonImage?.withTintColor(.label, renderingMode:.alwaysOriginal), for: .normal)
        sortButton.setImage(sortButtonImage?.withTintColor(.secondaryLabel, renderingMode:.alwaysOriginal), for: .highlighted)
        sortButton.contentVerticalAlignment = .fill
        sortButton.contentHorizontalAlignment = .fill
        sortButton.addTarget(self, action: #selector(changeSortMethod), for: .touchUpInside)
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(sortButton)
        sortButton.clipsToBounds = true
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.SortRightMargin),
            sortButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.SortBottomMarginForLargeState),
            sortButton.heightAnchor.constraint(equalToConstant: Const.SortSizeForLargeState),
            sortButton.widthAnchor.constraint(equalTo: sortButton.heightAnchor)
        ])
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Const.SortSizeForSmallState / Const.SortSizeForLargeState

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        let sizeDiff = Const.SortSizeForLargeState * (1.0 - factor)
        let yTranslation: CGFloat = {
            let maxYTranslation = Const.SortBottomMarginForLargeState - Const.SortBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.SortBottomMarginForSmallState + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        sortButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.sortButton.alpha = show ? 1.0 : 0
        }
    }
    
    // MARK: Sort Button Action
    
    @objc func changeSortMethod(sender: UIButton!) {
        let sortMenu = UIAlertController(title: "Сортировать по:", message: nil, preferredStyle: .actionSheet)
        
        let dailyAction = UIAlertAction(title: "Дням", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortedBy = .daily
        })
        let monthAction = UIAlertAction(title: "Месяцам", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sortedBy = .monthly
        })
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel)
        
        sortMenu.addAction(dailyAction)
        sortMenu.addAction(monthAction)
        sortMenu.addAction(cancelAction)
        
        self.present(sortMenu, animated: true, completion: nil)
    }
    
    // MARK: TableView Setup
    
    // TODO: Getting transaction from a database
    
    var transactions = [
        Transaction(date: parseDate("2020-06-17"), number: -233, category: "Продукты"),
        Transaction(date: parseDate("2020-06-15"), number: -224, category: "Продукты"),
        Transaction(date: parseDate("2020-07-15"), number: 23, category: "Работа")
    ]
    
    var sections = [GroupedSection<Date, Transaction>]()
    
    func generateSections() {
        if sortedBy == .monthly {
            self.sections = GroupedSection.group(rows: self.transactions, by: { firstDayOfMonth(date: $0.date) })
            self.sections.sort { lhs, rhs in lhs.sectionItem > rhs.sectionItem }
        } else {
            self.sections = GroupedSection.group(rows: self.transactions, by: { $0.date })
            self.sections.sort { lhs, rhs in lhs.sectionItem > rhs.sectionItem }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        generateSections()
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch sortedBy {
        case .monthly:
            let section = self.sections[section]
            let date = section.sectionItem
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            return dateFormatter.string(from: date)
        case .daily:
            let section = self.sections[section]
            let date = section.sectionItem
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            return dateFormatter.string(from: date)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionCell

        let section = self.sections[indexPath.section]
        let transaction = section.rows[indexPath.row]

        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        let localeCode = Locale.current.currencyCode
        
        if localeCode == "RUB" {
            currencyFormatter.locale = Locale.init(identifier: "ru_RU") }
        else { currencyFormatter.locale = Locale.current }
        
        var priceString: String = ""
        
        let intSettingIsSet = true
        if intSettingIsSet {
            // TODO: В зависимости от настроек передается Int или Float
            currencyFormatter.maximumFractionDigits = 0
            currencyFormatter.minimumFractionDigits = 0
            priceString = currencyFormatter.string(from: NSNumber(value: transaction.number))!

        } else {
            priceString = currencyFormatter.string(from: NSNumber(value: transaction.number))!
        }
        
        if transaction.number > 0 {
            cell.numberLabel.text = "+\(priceString)"
            cell.numberLabel.textColor = UIColor(red: 0.792, green: 0.443, blue: 0.443, alpha: 1)
        } else {
            cell.numberLabel.text = priceString
            cell.numberLabel.textColor = UIColor(red: 0.451, green: 0.792, blue: 0.443, alpha: 1)
        }
        
        cell.categoryLabel.text = transaction.category
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toTransaction", sender: nil)
    }
    
}
