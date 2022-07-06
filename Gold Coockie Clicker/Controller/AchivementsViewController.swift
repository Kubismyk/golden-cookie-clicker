//
//  AchivementsViewController.swift
//  Gold Coockie Clicker
//
//  Created by Levan Charuashvili on 08.03.22.
//

import UIKit

class AchivementsViewController: UIViewController {

    @IBOutlet weak var achivementImage: UIImageView!
    @IBOutlet weak var achivementName: UILabel!
    @IBOutlet weak var achivementInfo: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        achivementImage.image = cookieImage
        achivementName.text = cookieTitle
        achivementInfo.text = info
        setupDesign()
    }
    
    var cookieImage = UIImage()
    var cookieTitle = String()
    var info = String()
    

    func configure(data:Achivement){
        self.cookieImage = data.image
        self.cookieTitle = data.title
        self.info = data.info
    }
    
    func setupDesign(){
        achivementName.dropShadowAndFont(fontSize: 43, shadowRadius: 4, shadowOpacity: 0.25, shadowX: 0, shadowY: 2, fontFamily: "Lobster")
        achivementInfo.dropShadowAndFont(fontSize: 17, shadowRadius: 4, shadowOpacity: 0.25, shadowX: 0, shadowY: 2, fontFamily: "Lobster")
    }
}
