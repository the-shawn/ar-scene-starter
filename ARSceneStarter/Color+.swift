//
//  Color+.swift
//  ARSceneStarter
//
//  Created by Nien Lam on 11/2/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        return .init(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1),
                     alpha: 1)
    }
    
    static var randomHue: UIColor {
        return .init(hue: .random(in: 0...1),
                     saturation: 1,
                     brightness: 1,
                     alpha: 1)
    }
    
    static var transparentTint: UIColor {
        .white.withAlphaComponent(0.9999999)
    }
}
