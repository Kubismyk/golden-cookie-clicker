//
//  Extensions.swift
//  Gold Coockie Clicker
//
//  Created by Levan Charuashvili on 28.02.22.
//

import Foundation
import UIKit
import AVFoundation

// uiview extensions



extension UIView {
// Rounded corner raius
    @IBInspectable var cornerRadius: CGFloat {
get {
return self.layer.cornerRadius
        }
set {
self.layer.cornerRadius = newValue
        }
    }
// Shadow color
    @IBInspectable var shadowColor: UIColor {
get {
return UIColor(cgColor: self.layer.shadowColor!)
        }
set {
self.layer.shadowColor = newValue.cgColor
        }
    }
// Shadow offsets
    @IBInspectable var shadowOffset: CGSize {
get {
return self.layer.shadowOffset
        }
set {
self.layer.shadowOffset = newValue
        }
    }
// Shadow opacity
    @IBInspectable var shadowOpacity: Double {
get {
    //return Double(self.layer.shadowOpacity)
    return 0.25
        }
set {
    //self.layer.shadowOpacity = Float(newValue)
    self.layer.shadowOpacity = 0.25
        }
    }
// Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
get {
return self.layer.shadowRadius
        }
set {
self.layer.shadowRadius = newValue
        }
    }
// Border width
    @IBInspectable var borderWidth: CGFloat {
get {
return self.layer.borderWidth
        }
set {
self.layer.borderWidth = newValue
        }
    }
// Border color
    @IBInspectable var borderColor: UIColor {
get {
return UIColor(cgColor: self.layer.borderColor!)
        }
set {
self.layer.borderColor = newValue.cgColor
        }
    }
// Background color
    @IBInspectable var layerBackgroundColor: UIColor {
get {
return UIColor(cgColor: self.layer.backgroundColor!)
        }
set {
self.backgroundColor = nil
self.layer.backgroundColor = newValue.cgColor
        }
    }
// Create bezier path of shadow for rasterize
    @IBInspectable var enableBezierPath: Bool {
get {
return self.layer.shadowPath != nil
        }
set {
if enableBezierPath {
self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            } else {
self.layer.shadowPath = nil
            }
        }
    }
// Mask to bounds controll
    @IBInspectable var maskToBounds: Bool {
get{
return self.layer.masksToBounds
        }
set {
self.layer.masksToBounds = newValue
        }
    }
// Rasterize option
    @IBInspectable var rasterize: Bool {
get {
return self.layer.shouldRasterize
        }
set {
self.layer.shouldRasterize = newValue
self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
}

// label extensions

extension UILabel {
    func dropShadowAndFont(fontSize:Int,shadowRadius:CGFloat,shadowOpacity:Float,shadowX:Int,shadowY:Int,fontFamily:String){
        self.font = UIFont(name: fontFamily, size: CGFloat(fontSize))
       self.layer.masksToBounds = false
       self.layer.shadowRadius = shadowRadius
       self.layer.shadowOpacity = shadowOpacity
       self.layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
    }
    
    func outlineText(text:String,fontSize:Double){
        let attrString = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeWidth: -2.0,
                NSAttributedString.Key.font: UIFont(name: "Lobster", size: fontSize)
            ]
        )
        self.attributedText = attrString
    }
}


//



class ViewWithRoundedcornersAndShadow: UIView {
    private var theShadowLayer: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()

        if self.theShadowLayer == nil {
            let rounding = CGFloat.init(22.0)

            let shadowLayer = CAShapeLayer.init()
            self.theShadowLayer = shadowLayer
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: rounding).cgPath
            shadowLayer.fillColor = UIColor(named: "CookiePink")?.cgColor

            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowRadius = CGFloat.init(3.0)
            shadowLayer.shadowOpacity = Float.init(0.2)
            shadowLayer.shadowOffset = CGSize.init(width: 0.0, height: 4.0)

            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}


// button extensions

extension UIButton {
    func buttonFontAndSize(fontFamily:String,fontSize:Double){
        self.titleLabel?.font = UIFont(name: fontFamily, size: fontSize)
    }
}

final class CustomButton: UIButton {

    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 28).cgPath
            shadowLayer.shadowColor = UIColor.black.cgColor
            //4267B2
            shadowLayer.fillColor = UIColor(named: "FacebookColor")?.cgColor
            
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0, height: 4.0)
            shadowLayer.shadowOpacity = 0.25
            shadowLayer.shadowRadius = 4

            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }

}


// animation

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.45
        animation.values = [-3.0, 3.0, -3.0, 7.0, -1.0, 1.0, -1.0, 1.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        Vibration.light.vibrate()
    }
    func shakeDenied() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.45
        animation.values = [-7.0, 7.0, -7.0, 12.0, -3.0, 3.0, -3.0, 3.0, 0.0 ]
        layer.add(animation, forKey: "shakeDenied")
        Vibration.error.vibrate()
    }
        
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}







// vibrations


enum Vibration {
      case error
      case success
      case warning
      case light
      case medium
      case heavy
      @available(iOS 13.0, *)
      case soft
      @available(iOS 13.0, *)
      case rigid
      case selection
      case oldSchool

      public func vibrate() {
          switch self {
          case .error:
              UINotificationFeedbackGenerator().notificationOccurred(.error)
          case .success:
              UINotificationFeedbackGenerator().notificationOccurred(.success)
          case .warning:
              UINotificationFeedbackGenerator().notificationOccurred(.warning)
          case .light:
              UIImpactFeedbackGenerator(style: .light).impactOccurred()
          case .medium:
              UIImpactFeedbackGenerator(style: .medium).impactOccurred()
          case .heavy:
              UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
          case .soft:
              if #available(iOS 13.0, *) {
                  UIImpactFeedbackGenerator(style: .soft).impactOccurred()
              }
          case .rigid:
              if #available(iOS 13.0, *) {
                  UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
              }
          case .selection:
              UISelectionFeedbackGenerator().selectionChanged()
          case .oldSchool:
              AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
          }
      }
  }

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
