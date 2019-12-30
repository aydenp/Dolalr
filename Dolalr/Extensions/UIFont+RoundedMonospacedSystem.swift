//
//  UIFont+RoundedMonospacedSystem.swift
//  Dolalr
//
//  Created by Ayden Panhuyzen on 2019-12-29.
//  Copyright © 2019 Ayden Panhuyzen. All rights reserved.
//

import UIKit

extension UIFont {
    static func roundedMonospacedDigitSystemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont? {
        let font = UIFont.monospacedDigitSystemFont(ofSize: size, weight: weight)
        
        guard let roundedDescriptor = font.fontDescriptor.withDesign(.rounded) else { return font }
        return UIFont(descriptor: roundedDescriptor, size: 0)
    }
    
}
