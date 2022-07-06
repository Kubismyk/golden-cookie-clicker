//
//  MenuViewController.swift
//  Gold Coockie Clicker
//
//  Created by Levan Charuashvili on 01.03.22.
//

import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: Int)
}

protocol TestDelegateProtocol {
    func sendData(myData:Int)
}

protocol SendSpinDelegateProtocol {
    func sendDataTo(myData:Double)
}

class MenuViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {



    static var delegate: MyDataSendingDelegateProtocol? = nil
    static var delegate2:TestDelegateProtocol? = nil
    static var delegate3:SendSpinDelegateProtocol? = nil
    
    
    @IBOutlet weak var achivementsCollectionView: UICollectionView!
    
    
    var moneyLevel:Int = 1
    var bonusLevel:Int = 1
    var spinLevel:Int = 1
    
    
    var userMoney = Int()
    static var moneyPerClickCost:Double = 10.0
    
    static var bonusTimeIntervalCost:Double = 10.0
    
    static var spinCost:Double = 10.0
    
    //static var
    
    @IBOutlet weak var notEnoughMoneyWarning: UILabel!
    
    @IBOutlet weak var upgradesLabel: UILabel!
    @IBOutlet weak var achivementLabel: UILabel!
    @IBOutlet var buttonsCollection: [UIButton]!
    
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        
        achivementsCollectionView.delegate = self
        achivementsCollectionView.dataSource = self
        achivementsCollectionView.backgroundColor = .none
        
        self.achivementsCollectionView.reloadData()
        
        updateButtons()
    }
    
    
    func setupDesign(){
        buttonsCollection.forEach { button in
            button.buttonFontAndSize(fontFamily: "Lobster", fontSize: 30)
        }
        upgradesLabel.dropShadowAndFont(fontSize: 50, shadowRadius: 4, shadowOpacity: 0.5, shadowX: 0, shadowY: 4, fontFamily: "Lobster")
        achivementLabel.dropShadowAndFont(fontSize: 40, shadowRadius: 4, shadowOpacity: 0.5, shadowX: 0, shadowY: 4, fontFamily: "Lobster")
    }
    
    @IBAction func upgradeMoneyPerClick(_ sender: UIButton) {
        if CookieViewController.test >=
            MenuViewController.moneyPerClickCost {
            
            notEnoughMoneyWarning.alpha = 0
            Vibration.success.vibrate()
            CookieViewController.moneyPerClick = CookieViewController.moneyPerClick * 1.15
            CookieViewController.moneyLevel += 1
            CookieViewController.test -= MenuViewController.moneyPerClickCost
            MenuViewController.moneyPerClickCost *= 1.5
            sender.shake()
            if MenuViewController.delegate != nil {
                let dataToBeSent = self.moneyLevel
                MenuViewController.delegate?.sendDataToFirstViewController(myData: dataToBeSent)
            }
            else {
                notEnoughMoneyWarning.text = "Something went wrong"
                notEnoughMoneyWarning.alpha = 1
                sender.shakeDenied()
            }
        } else {
            notEnoughMoneyWarning.text = "not enough cookies"
            notEnoughMoneyWarning.alpha = 1
            sender.shakeDenied()
        }
        updateButtons()
        
    }
    
    @IBAction func upgradeBonus(_ sender: UIButton) {
        if CookieViewController.test >= MenuViewController.bonusTimeIntervalCost {
            
            notEnoughMoneyWarning.alpha = 0
            CookieViewController.cookieBonus += 2
            Vibration.success.vibrate()
            CookieViewController.test = CookieViewController.test - MenuViewController.bonusTimeIntervalCost
            CookieViewController.bonusLevel += 1
            MenuViewController.bonusTimeIntervalCost *= 1.5
            sender.shake()
            if MenuViewController.delegate != nil {
                let dataToBeSent = self.bonusLevel
                MenuViewController.delegate2?.sendData(myData: dataToBeSent)
            }
            else {
                notEnoughMoneyWarning.text = "Something went wrong"
                notEnoughMoneyWarning.alpha = 1
                sender.shakeDenied()
            }
        } else {
            notEnoughMoneyWarning.text = "not enough cookies"
            notEnoughMoneyWarning.alpha = 1
            sender.shakeDenied()
        }
        updateButtons()
    }
    static var spinTime = 4.0
    @IBAction func cookieSpinTimeUpgrade(_ sender: UIButton) {
        if CookieViewController.test >= MenuViewController.spinCost {
            
            notEnoughMoneyWarning.alpha = 0
            MenuViewController.spinTime -= 0.15
            Vibration.success.vibrate()
            CookieViewController.test = CookieViewController.test - MenuViewController.spinCost
            CookieViewController.spinLevel += 1
            MenuViewController.spinCost *= 3
            let spinTimeMinus = 0.15
            sender.shake()
            updateButtons()
            if MenuViewController.delegate != nil {
                let dataToBeSent = spinTimeMinus
                MenuViewController.delegate3?.sendDataTo(myData: Double(dataToBeSent))
            }
            else {
                notEnoughMoneyWarning.text = "Something went wrong"
                notEnoughMoneyWarning.alpha = 1
                sender.shakeDenied()
            }
        }
        else {
            notEnoughMoneyWarning.text = "not enough cookies"
            notEnoughMoneyWarning.alpha = 1
            sender.shakeDenied()
        }
    }
    
    
    
    
    func updateButtons(){
        firstButton.setTitle("tap per click:\(String(format: "%.2f", CookieViewController.moneyPerClick)), cost: \(Int(MenuViewController.moneyPerClickCost))", for: .normal)
        secondButton.setTitle("money per spin:\(String(format: "%.2f", CookieViewController.cookieBonus)), cost: \(Int(MenuViewController.bonusTimeIntervalCost))", for: .normal)
        thirdButton.setTitle("spin speed:\(String(format: "%.2f", MenuViewController.spinTime)), cost: \(Int(MenuViewController.spinCost))", for: .normal)
    }
    
    static var achivementsArray:[Achivement] = [
        Achivement(image: UIImage(named: "MainCookie")!, title: "normal", info: "to achieve this, you just need download and play the game for the first time",achieved: true, cookieImage: UIImage(named: "MainCookie")!),
        Achivement(image: UIImage(named: "bronze")!, title: "bronze", info: "to get this achivement, you need to achieve at least level 3",achieved: false, cookieImage: UIImage(named: "bronze")!),
        Achivement(image: UIImage(named: "cheese")!, title: "cheese", info: "to get cheese cookie, you need to get 5 cookie per click",achieved: false, cookieImage: UIImage(named: "cheese")!),
        Achivement(image: UIImage(named: "MoneyPerSpinCookie")!, title: "cookies everywhere", info: "to get this you need to upgrade cookie per spin to level ten",achieved: false, cookieImage: UIImage(named: "MoneyPerSpinCookie")!),
        Achivement(image: UIImage(named: "SevenLevelCookie")!, title: "wow, cool!", info: "to get it, get level 7",achieved: false, cookieImage: UIImage(named: "SevenLevelCookie")!),
        Achivement(image: UIImage(named: "1million")!, title: "millionarie", info: "to achieve this, you have to get one million money",achieved: false, cookieImage: UIImage(named: "MillionCookie")!),
        Achivement(image: UIImage(named: "1225click")!, title: "1225", info: "click the cookie 1225 times",achieved: false, cookieImage: UIImage(named: "1225click")!),
        Achivement(image: UIImage(named: "OneSecondCookie")!, title: "Money Every Second", info: "to get this, decrease spin of cookie to 1 second",achieved: false, cookieImage: UIImage(named: "OneSecondCookie")!),
        Achivement(image: UIImage(named: "SecretCookie")!, title: "secret", info: "to get this rare achivement, you need to have specific amount of levels of upgrade",achieved: false, cookieImage: UIImage(named: "SecretCookie")!),
        Achivement(image: UIImage(named: "Billion")!, title: "Billionarie", info: "to achieve this, you need to get one billion cookies",achieved: false, cookieImage: UIImage(named: "BillionCookie")!),
        Achivement(image: UIImage(named: "GoldCookie")!, title: "Gold Cookie Clicker", info: "Reach the maximum level,it can be 9 or 19, maybe 12 or less than that, if you see different color rather than white on levels text, that means you got this badge", achieved: false, cookieImage: UIImage(named: "GoldCookie")!)
    ]
    static var delegate4: FooTwoViewControllerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MenuViewController.achivementsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath as IndexPath) as! AchivementsCollectionViewCell
        cell.config(data: MenuViewController.achivementsArray[indexPath.row])
        cell.setupDesign()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var selectedBadge = MenuViewController.achivementsArray[indexPath.row]
        if selectedBadge.achieved {
            Vibration.light.vibrate()
            var selectedBadgeImage = MenuViewController.achivementsArray[indexPath.row].cookieImage
            MenuViewController.delegate4?.sendAchivementImageData(achivementImage: selectedBadgeImage)
            dismiss(animated: true, completion: nil)
        } else {
            Vibration.error.vibrate()
            notEnoughMoneyWarning.text = "You havent achieved this yet"
            notEnoughMoneyWarning.alpha = 1
            let backDropActionSheet = UIStoryboard(name: "Cookie", bundle: nil).instantiateViewController(withIdentifier: "AchivementsViewController") as! AchivementsViewController
            if let sheet = backDropActionSheet.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.preferredCornerRadius = 30
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.prefersGrabberVisible = true
            }
            backDropActionSheet.configure(data: MenuViewController.achivementsArray[indexPath.row])
            self.present(backDropActionSheet,animated: true,completion: nil)
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.height/2, height: collectionView.frame.height/2)

    }

    
    

}
struct Achivement {
    var image:UIImage
    var title:String
    var info:String
    var achieved:Bool
    var cookieImage:UIImage
}

protocol FooTwoViewControllerDelegate:class {
    func sendAchivementImageData(achivementImage:UIImage)
}
