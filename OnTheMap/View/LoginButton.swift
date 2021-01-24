//
//  LoginButton.swift
//  OnTheMap
//
//  Created by nang saw on 16/01/2021.
//

import UIKit

class LoginButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.systemTeal
    }

}
