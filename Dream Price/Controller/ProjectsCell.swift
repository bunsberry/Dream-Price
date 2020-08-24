//
//  ProjectsCell.swift
//  Dream Price
//
//  Created by Georg on 19.07.2020.
//

import UIKit
import RealmSwift

class ProjectsCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let realm = try! Realm()
    var projects: Results<RealmProject>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        projects = realm.objects(RealmProject.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ProjectsCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProjectCell", for: indexPath) as! AddProjectCVCell
            
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.cornerRadius = cell.frame.width / 10
            cell.addProjectLabel.textColor = UIColor(red: 0.842, green: 0.477, blue: 0.477, alpha: 1)
            cell.plusLabel.textColor = UIColor(red: 0.842, green: 0.477, blue: 0.477, alpha: 1)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCCell", for: indexPath) as! ProjectCVCell
            
            cell.name.text = projects[indexPath.row].name
            cell.details.text = projects[indexPath.row].details
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 178.0
        let height = 256.0
        return CGSize(width: width, height: height)
    }
}
