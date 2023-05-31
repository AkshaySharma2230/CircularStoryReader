//
//  StoryCVC.swift
//  CircularStoryReader
//
//  Created by Akshay Kumar on 31/05/23.
//

import UIKit

class StoryCVC: UICollectionViewCell {

    //MARK: Cell Outlets
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorView.layer.cornerRadius = 38
        userImageView.layer.cornerRadius = 30
        // Initialization code
    }

}
