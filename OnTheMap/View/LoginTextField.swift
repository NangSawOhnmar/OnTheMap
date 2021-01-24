//
//  LoginTextField.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import UIKit

class LoginTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 5
        tintColor = UIColor.black
        backgroundColor = UIColor.white
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.size.width - 16, height: bounds.size.height)
        return insetBounds
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetBounds = CGRect(x: bounds.origin.x + 8, y: bounds.origin.y, width: bounds.size.width - 16, height: bounds.size.height)
        return insetBounds
    }
}
