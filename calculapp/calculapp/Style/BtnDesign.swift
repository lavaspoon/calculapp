//
//  BtnDesign.swift
//  calculapp
//
//  Created by lavaspoon on 2021/10/24.
//

import UIKit

@IBDesignable
class BtnDesign: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 10{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

