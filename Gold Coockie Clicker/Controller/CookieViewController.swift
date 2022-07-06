//
//  CookieViewController.swift
//  Gold Coockie Clicker
//
//  Created by Levan Charuashvili on 28.02.22.
//

import UIKit
import Lottie


class CookieViewController: UIViewController, MyDataSendingDelegateProtocol,TestDelegateProtocol,SendSpinDelegateProtocol,FooTwoViewControllerDelegate {
    func sendAchivementImageData(achivementImage: UIImage) {
        self.bigCookie.image = achivementImage
    }
    
    func sendData(myData: Int) {
        self.bonusLevel = myData
    }
    
    func sendDataTo(myData: Double) {
        self.spinLevel = Int(myData)
        self.cookieTimeInterval = self.cookieTimeInterval - myData
        addMoneyWithCookieTime()
    }
    
    func sendDataToFirstViewController(myData: Int) {
        self.collectedMoneyLevel = myData
    }
    
    
    
    var collectedMoney = Double() {
        didSet {
            self.moneyLabel.text =
                String(format: "%.2f", collectedMoney)
        }
    }
    var collectedMoneyLevel = 1 {
        didSet {
            self.moneyLevelLabel.text = String(CookieViewController.moneyLevel)
            self.collectedMoney = CookieViewController.test
        }
    }
    var bonusLevel = 1 {
        didSet {
            self.bonusLevelLabel.text = String(CookieViewController.bonusLevel)
            self.collectedMoney = CookieViewController.test
        }
    }
    
    var spinLevel = 1 {
        didSet {
            self.spinLevelLabel.text = String(CookieViewController.spinLevel)
            self.collectedMoney = CookieViewController.test
        }
    }
    
    var pX: CGFloat = 0
    var pY: CGFloat = 0
    
    
    
    static var moneyPerClick:Double = 1
    
    static var moneyLevel:Int = 1
    static var bonusLevel:Int = 1
    static var spinLevel:Int = 1
    
    var cookieTimeInterval:Double = 4.0 {
        didSet {
            self.rotate()
            self.addMoneyWithCookieTime()
        }
    }
    static var cookieBonus:Double = 2.5
    
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var moneyLevelLabel: UILabel!
    @IBOutlet weak var bonusLevelLabel: UILabel!
    @IBOutlet weak var spinLevelLabel: UILabel!
    
    @IBOutlet weak var bigCookie: UIImageView!
    @IBOutlet weak var moneyView: UIView!
    
    @IBOutlet weak var levelsLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    
    var clickCount:Int = 0 // firebase
    
    
    
    @IBOutlet weak var newAchivementUnlocked: UIView!
    @IBOutlet weak var newAchivementLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotate()
        setupDesign()
        addMoneyWithCookieTime()
        
        self.collectedMoney = 1_000_000_000_000
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        bigCookie.isUserInteractionEnabled = true
        bigCookie.addGestureRecognizer(tapGestureRecognizer)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //spinTheCookie()
        rotate()
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MenuViewController.delegate = self // delegate to send money level
        MenuViewController.delegate2 = self
        MenuViewController.delegate3 = self
        MenuViewController.delegate4 = self
    }
    
    
    
    static var test = Double()
    



    func setupDesign(){
        levelsLabel.dropShadowAndFont(fontSize: 120, shadowRadius: 4, shadowOpacity: 0.25, shadowX: 0, shadowY: 4, fontFamily: "Lobster")
        newAchivementLabel.dropShadowAndFont(fontSize: 20, shadowRadius: 4, shadowOpacity: 0.25, shadowX: 0, shadowY: 4, fontFamily: "Lobster")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: bigCookie)
            self.pX = position.x
            self.pY = position.y
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        Vibration.medium.vibrate()

        checkLevelUp()

        clickCount += 1
        
        collectedMoney += Double(CookieViewController.moneyPerClick)
        CookieViewController.test = collectedMoney
        
        
        let label = UILabel(frame: CGRect(x: pX-100, y: pY+250, width: 70, height: 31))
        label.textAlignment = .center
        label.outlineText(text: "\(String(format: "%.1f", (Double(CookieViewController.moneyPerClick))))", fontSize: 35)
        
        

        self.view.addSubview(label)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            UIView.animate(withDuration: 0.8, animations:{
                label.alpha = 0
                label.frame = CGRect(x: self.pX, y: self.pY-60, width: 70, height: 31)
            }, completion: { done in
                if done {
                    label.removeFromSuperview()
                    label.transform = CGAffineTransform.identity
                }

            })
        })

    }
    
    func addMoneyWithCookieTime(){
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.cookieTimeInterval), repeats: true) { timer in
            self.collectedMoney += Double(CookieViewController.cookieBonus)
        }
    }
    
    func spinTheCookie(){
        let orbit = CAKeyframeAnimation(keyPath: "position")
        var affineTransform = CGAffineTransform(rotationAngle: 0.0)
        affineTransform = affineTransform.rotated(by: CGFloat(Double.pi))
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: 0,y: 0), radius:  CGFloat(1), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        orbit.path = circlePath.cgPath
        orbit.duration = CFTimeInterval(self.cookieTimeInterval)
        orbit.isAdditive = true
        orbit.repeatCount = .infinity
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto
        
        
        
        
        bigCookie.layer.add(orbit, forKey: "orbit")
        
        
        
        
    }
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = CFTimeInterval(self.cookieTimeInterval)
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        bigCookie.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func levelUpAnimation(){
        let animationView = AnimationView(name: "85744-success")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            UIView.animate(withDuration: 3, animations:{ [self] in
                animationView.frame = CGRect(x: 0, y: 0, width: 179, height: 178)
                animationView.center = self.animationView.center
                animationView.contentMode = .scaleAspectFill
                view.addSubview(animationView)
                animationView.play()
            }, completion: { [self] done in
                if done {
                    animationView.removeFromSuperview()
                }
            })

    })

    }
    
    
    
    func levelUpFunction(levelToAchieve:Int, leveltoGet:Int){
            if CookieViewController.moneyLevel >= levelToAchieve &&
                CookieViewController.bonusLevel >= levelToAchieve &&
                CookieViewController.spinLevel >= levelToAchieve {
                level = leveltoGet
                self.levelsLabel.text = String(self.level)
            } else {
                return
            }
    }
    
    
    
    
    func newAchivementUnlockedPopUp(){
        Vibration.light.vibrate()
        newAchivementLabel.text = "New achivement unlocked, check it out in the menu"
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            UIView.animate(withDuration: 1, animations:{ [self] in
                newAchivementUnlocked.frame = CGRect(x: 40, y: 820, width: 334, height: 65)
                newAchivementUnlocked.alpha = 1
            }, completion: { [self] done in
                if done {
                    DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                        UIView.animate(withDuration: 1) {
                            newAchivementUnlocked.alpha = 0
                        } completion: { [self] done in
                            newAchivementUnlocked.alpha = 0
                        }
                            
                    })
                }
            })

    })
}
    
    func levelUpPopUp(){
        Vibration.light.vibrate()
        newAchivementLabel.text = "Level up \nCongratulations"
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            UIView.animate(withDuration: 1, animations:{ [self] in
                newAchivementUnlocked.frame = CGRect(x: 40, y: 820, width: 334, height: 65)
                newAchivementUnlocked.alpha = 1
            }, completion: { [self] done in
                if done {
                    DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
                        UIView.animate(withDuration: 1) {
                            newAchivementUnlocked.alpha = 0
                        } completion: { [self] done in
                            newAchivementUnlocked.alpha = 0
                        }
                            
                    })
                }
            })

    })
}
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var level:Int = 1
    
    // functions you might not want to know below
    
    
    var isMillionarie = false
    func checkMillionarieBadge() {
        guard !isMillionarie else {
            return // return out of the function if `didLevelUp` is not false
        }
        if collectedMoney > 1_000_000 {
            MenuViewController.achivementsArray[5].achieved = true
            isMillionarie = true
        }
    }
    
    
    var firstLevel = false
    var secondLevel = false
    var thirdlevel = false
    var fourthLevel = false
    var fifthLevel = false
    var sixthLevel = false
    var seventhLevel = false
    var eightLevel = false
    var ninethLevel = false
    var tenthLevel = false
    var eleventh = false
    var twelveth = false
    var thirteenth = false
    
    
    
    func firstLevelUp() {
        guard !firstLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 3 &&
            CookieViewController.bonusLevel >= 3 &&
            CookieViewController.spinLevel >= 3 {
            level = 2
            self.levelsLabel.text = String(self.level)
            firstLevel = true
            MenuViewController.achivementsArray[1].achieved = firstLevel
            newAchivementUnlockedPopUp()
            levelUpAnimation()
        }
    }
    func secondLevelUp() {
        guard !secondLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 5 &&
            CookieViewController.bonusLevel >= 5 &&
            CookieViewController.spinLevel >= 5 {
            level = 3
            self.levelsLabel.text = String(self.level)
            secondLevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func thirdLevelUp() {
        guard !thirdlevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 7 &&
            CookieViewController.bonusLevel >= 7 &&
            CookieViewController.spinLevel >= 7 {
            level = 4
            self.levelsLabel.text = String(self.level)
            thirdlevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func fourthLevelUp() {
        guard !fourthLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 9 &&
            CookieViewController.bonusLevel >= 9 &&
            CookieViewController.spinLevel >= 9 {
            level = 5
            self.levelsLabel.text = String(self.level)
            fourthLevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func fifthLevelUp() {
        guard !fifthLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 11 &&
            CookieViewController.bonusLevel >= 11 &&
            CookieViewController.spinLevel >= 11 {
            level = 6
            self.levelsLabel.text = String(self.level)
            fifthLevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func sixthLevelUp() {
        guard !sixthLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 13 &&
            CookieViewController.bonusLevel >= 13 &&
            CookieViewController.spinLevel >= 13 {
            level = 7
            self.levelsLabel.text = String(self.level)
            sixthLevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func seventhLevelUp() {
        guard !seventhLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 15 &&
            CookieViewController.bonusLevel >= 15 &&
            CookieViewController.spinLevel >= 15 {
            level = 8
            self.levelsLabel.text = String(self.level)
            seventhLevel = true
            MenuViewController.achivementsArray[6].achieved = seventhLevel
            newAchivementUnlockedPopUp()
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func eightLevelUp() {
        guard !eightLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 17 &&
            CookieViewController.bonusLevel >= 17 &&
            CookieViewController.spinLevel >= 17 {
            level = 9
            self.levelsLabel.text = String(self.level)
            eightLevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func ninethLevelUp() {
        guard !ninethLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 19 &&
            CookieViewController.bonusLevel >= 19 &&
            CookieViewController.spinLevel >= 19 {
            level = 10
            self.levelsLabel.text = String(self.level)
            ninethLevel = true
            levelUpAnimation()
            levelUpPopUp()
        }
    }
    func tenthLevelUp() {
        guard !tenthLevel else {
            return // return out of the function if `didLevelUp` is not false
        }
        if CookieViewController.moneyLevel >= 21 &&
            CookieViewController.bonusLevel >= 21 &&
            CookieViewController.spinLevel >= 21 {
            level = 11
            self.levelsLabel.text = String(self.level)
            tenthLevel = true
            levelUpAnimation()
            levelUpPopUp()
            self.levelsLabel.textColor = UIColor(rgb: 0xFFD700)
        }
    }
    
    //achivements
    
    var isCheeseAchieved = false
    
    func cheeseCookieAchivement(){
        guard !isCheeseAchieved else {
            return
        }
        if CookieViewController.moneyPerClick >= 5 {
            isCheeseAchieved = true
            MenuViewController.achivementsArray[2].achieved = isCheeseAchieved
            newAchivementUnlockedPopUp()
        }
    }
    
    var isBillionarie = false
    
    func billionarieAchivement(){
        guard !isBillionarie else {
            return
        }
        if collectedMoney >= 1_000_000_000 {
            isBillionarie = true
            MenuViewController.achivementsArray[9].achieved = isBillionarie
            newAchivementUnlockedPopUp()
        }
    }
    
    var secretCodeUnlocked = false
    
    func secretCodeAchivement(){
        guard !secretCodeUnlocked else {
            return
        }
        if CookieViewController.moneyLevel == 11 &&
            CookieViewController.bonusLevel == 13 &&
            CookieViewController.spinLevel == 15 {
            secretCodeUnlocked = true
            MenuViewController.achivementsArray[8].achieved = secretCodeUnlocked
            newAchivementUnlockedPopUp()
        }
    }
    
    var levelTenOfSecondAchivement = false
    
    func moneyPerSpinAchivement() {
        guard !levelTenOfSecondAchivement else {
            return
        }
        if CookieViewController.bonusLevel >= 10 {
            levelTenOfSecondAchivement = true
            MenuViewController.achivementsArray[3].achieved = levelTenOfSecondAchivement
            newAchivementUnlockedPopUp()
        }
    }
    
    var oneSecondCookie = false
    
    func moneyEverySecondAchivement() {
        guard !oneSecondCookie else {
            return
        }
        if cookieTimeInterval <= 1 {
            oneSecondCookie = true
            MenuViewController.achivementsArray[7].achieved = oneSecondCookie
            newAchivementUnlockedPopUp()
        }
    }
    
    var clicked1125Times = false
    
    func click1125TimesAchivement(){
        guard !clicked1125Times else {
            return
        }
        if clickCount >= 1225 {
            clicked1125Times = true
            MenuViewController.achivementsArray[6].achieved = clicked1125Times
            newAchivementUnlockedPopUp()
        }
    }
    
    var isGoldenCookie = false
    func goldenCookie(){
        guard !isGoldenCookie else {
            return
        }
        if level == 11 {
            isGoldenCookie = true
            MenuViewController.achivementsArray[10].achieved = isGoldenCookie
            newAchivementUnlockedPopUp()
        }
    }
    
    
    
    func checkLevelUp() {
        goldenCookie()
        click1125TimesAchivement()
        moneyEverySecondAchivement()
        checkMillionarieBadge()
        secretCodeAchivement()
        firstLevelUp()
        moneyPerSpinAchivement()
        secondLevelUp()
        thirdLevelUp()
        fourthLevelUp()
        fifthLevelUp()
        sixthLevelUp()
        seventhLevelUp()
        eightLevelUp()
        ninethLevelUp()
        tenthLevelUp()
        cheeseCookieAchivement()
        billionarieAchivement()
    }
    
    
}
