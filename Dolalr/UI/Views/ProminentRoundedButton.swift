//
//  ProminentRoundedButton.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

class ProminentRoundedButton: RoundedButton {
    
    override func setupColours() {
        setTitleColor(.white, for: .normal)
        backgroundColor = tintColor
    }
    
}
