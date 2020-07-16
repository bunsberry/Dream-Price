//
//  DreamsVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 14.07.2020.
//

import UIKit

enum DreamType {
    case main
    case justDream
}

struct Dreams {
    let type: DreamType
    let title: String
    let description: String
    let reqSum: Int
}


class DreamsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var DreamsList: [Dreams] = [
        Dreams(type: .main, title: "BMW M5", description: "Best car ever", reqSum: 5000000),
        Dreams(type: .justDream, title: "New home", description: "In Moscow", reqSum: 10000000),
        ]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //collectionView.contentInset = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
        
        let w = UIScreen.main.bounds.size.width 
        return CGSize(width: w, height: 100)
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.allowsSelection = true
        return DreamsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if DreamsList[indexPath.row].type == .main {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainDreamCell
            
            cell.titleLabel.text = DreamsList[indexPath.row].title
            cell.descriptionLabel.text = DreamsList[indexPath.row].description
            cell.reqLabel.text = "\(DreamsList[indexPath.row].reqSum)₽"
            cell.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            cell.cellView.layer.cornerRadius = 20
            cell.cellView.layer.shadowColor = UIColor.black.cgColor
            cell.cellView.layer.shadowRadius = 1
            cell.cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.cellView.layer.shadowOpacity = 0.6
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DreamCell
            
            cell.titleLabel.text = DreamsList[indexPath.row].title
            cell.descriptionLabel.text = DreamsList[indexPath.row].description
            cell.reqLabel.text = "\(DreamsList[indexPath.row].reqSum)₽"
            
            return cell
        }
    }
/*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? DreamCell
        cell?.descriptionLabel.textColor = UIColor.secondaryLabel
        cell?.titleLabel.textColor = UIColor.label
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? MainDreamCell
        cell?.titleLabel.textColor = UIColor.label
        cell?.descriptionLabel.textColor = UIColor.secondaryLabel
    }
*/
}
