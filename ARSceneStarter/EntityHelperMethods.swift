//
//  EntityHelperMethods.swift
//  ARSceneStarter
//
//  Created by Nien Lam on 10/4/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI
import RealityKit

/// Utility methods for custom entities.


// MARK: - Create entity with USDZ model.

func makeModelEntity(name: String, usdzModelName: String) -> ModelEntity {
    let model = try! ModelEntity.loadModel(named: usdzModelName)
    model.name = name
    
    return model
}

extension ModelEntity {
    func animate(_ animate: Bool) {
        if animate {
            if let animation = self.availableAnimations.first {
                self.playAnimation(animation.repeat())
            }
        } else {
            self.stopAllAnimations()
        }
    }
}


// MARK: - Create box entity with width, height, depth and color or image.

func makeBoxEntity(name: String, width: Float, height: Float, depth: Float, color: UIColor) -> ModelEntity {
    let material = SimpleMaterial(color: color, isMetallic: false)
    
    let model = ModelEntity(mesh: .generateBox(width: width, height: height, depth: depth), materials: [material])
    model.name = name
    
    return model
}

func makeBoxEntity(name: String, width: Float, height: Float, depth: Float, imageName: String,
                   tintColor: UIColor = .white.withAlphaComponent(0.999)) -> ModelEntity {
    var material = SimpleMaterial()
    material.color = .init(tint: tintColor, texture: .init(try! .load(named: imageName)))
    
    let model = ModelEntity(mesh: .generateBox(width: width, height: height, depth: depth), materials: [material])
    model.name = name
    
    return model
}


// MARK: - Create sphere entity with radius and color or image.

func makeSphereEntity(name: String, radius: Float, color: UIColor) -> ModelEntity {
    let material = SimpleMaterial(color: color, isMetallic: false)
    
    let model = ModelEntity(mesh: .generateSphere(radius: radius), materials: [material])
    model.name = name
    
    return model
}

func makeSphereEntity(name: String, radius: Float, imageName: String,
                      tintColor: UIColor = .white.withAlphaComponent(0.999)) -> ModelEntity {
    var material = SimpleMaterial()
    material.color = .init(tint: tintColor, texture: .init(try! .load(named: imageName)))

    let model = ModelEntity(mesh: .generateSphere(radius: radius), materials: [material])
    model.name = name
    
    return model
}
