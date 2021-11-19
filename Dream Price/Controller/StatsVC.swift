//
//  StatsVC.swift
//  Dream Price
//
//  Created by Kostya Bunsberry on 16.11.2021.
//

import UIKit

class StatsVC: UIViewController {
    
    @IBOutlet weak var statsCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        statsCollectionView.dataSource = self
        statsCollectionView.delegate = self
    }
    

}

extension StatsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "charCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width - 40, height: 50)
        }
        
        return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.width - 40)
    }
}
