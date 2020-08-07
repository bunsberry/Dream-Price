//
//  CategoryCollectionVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

extension BudgetVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        
        let w = UIScreen.main.bounds.size.width / 4
        return CGSize(width: w, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.allowsSelection = true
        return categoriesShown.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if categoriesShown[indexPath.row].type == .manage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "manageCategories", for: indexPath) as! ManageCategoriesCell
            
            cell.manageView.layer.cornerRadius = 10
            cell.manageView.layer.borderWidth = 1
            cell.manageView.layer.borderColor = UIColor.secondaryLabel.cgColor
            
            cell.manageButton.setTitleColor(UIColor.secondaryLabel, for: .normal)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category", for: indexPath) as! CategoryCell
            
            if cell == selectedCategoryCell {
                cell.categoryView.layer.borderWidth = 1.5
                cell.categoryView.layer.borderColor = UIColor.label.cgColor
                cell.titleLabel.textColor = UIColor.label
            } else {
                cell.categoryView.layer.borderWidth = 1
                cell.categoryView.layer.borderColor = UIColor.secondaryLabel.cgColor
                cell.titleLabel.textColor = UIColor.secondaryLabel
            }
            cell.categoryView.layer.cornerRadius = 25
            cell.titleLabel.text = categoriesShown[indexPath.row].title
            cell.categoryID = categoriesShown[indexPath.row].categoryID
            
            if categoriesShown[indexPath.row].type == .budget {
                cell.categoryView.layer.cornerRadius = 10
            }
            
            cell.categoryType = categoriesShown[indexPath.row].type
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.titleLabel.textColor = UIColor.label
        cell.categoryView.layer.borderColor = UIColor.label.cgColor
        cell.categoryView.layer.borderWidth = 1.5
        
        selectedCategoryPath = indexPath
        selectedCategoryCell = cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
        cell?.titleLabel.textColor = UIColor.secondaryLabel
        cell?.categoryView.layer.borderColor = UIColor.secondaryLabel.cgColor
        cell?.categoryView.layer.borderWidth = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.cellForItem(at: indexPath)?.isSelected == true {
            
            collectionView.deselectItem(at: indexPath, animated: true)
            
            let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell
            cell?.titleLabel.textColor = UIColor.secondaryLabel
            cell?.categoryView.layer.borderColor = UIColor.secondaryLabel.cgColor
            cell?.categoryView.layer.borderWidth = 1
            
            selectedCategoryPath = nil
            selectedCategoryCell = nil
            
            return false
        } else {
            return true
        }
    }
}
