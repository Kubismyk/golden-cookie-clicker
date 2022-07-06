//
//  AchivementsCollectionViewCell.swift
//  Gold Coockie Clicker
//
//  Created by Levan Charuashvili on 07.03.22.
//

import UIKit

class AchivementsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var achivementImage: UIImageView!
    @IBOutlet weak var achivementsTitle: UILabel!
    var info = String()
    var achieved = Bool()
    @IBOutlet weak var notAchieved: UIView!
    
    func setupDesign(){
        self.achivementsTitle.dropShadowAndFont(fontSize: 20, shadowRadius: 10, shadowOpacity: 0.25, shadowX: 0, shadowY: 2, fontFamily: "Lobster")
        self.achivementsTitle.textColor = .white
        if achieved {
            self.notAchieved.alpha = 0
        } else {
            self.notAchieved.alpha = 1
        }
    }
    
    func config(data:Achivement){
        self.achivementImage.image = data.image
        self.achivementsTitle.text = data.title
        self.info = data.info
        self.achieved = data.achieved
    }
    
}
