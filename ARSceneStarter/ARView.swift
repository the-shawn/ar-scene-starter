//
//  ARView.swift
//  ARSceneStarter
//
//  Created by Nien Lam on 11/1/23.
//  Copyright © 2023 Line Break, LLC. All rights reserved.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

// SwiftUI Wrapper.
struct ARViewContainer: UIViewRepresentable {
    let viewModel: ViewModel
    
    func makeUIView(context: Context) -> CustomARView {
        CustomARView(frame: .zero, viewModel: viewModel)
    }
    
    func updateUIView(_ arView: CustomARView, context: Context) { }
}

// Custom ARView.
class CustomARView: ARView {
    var viewModel: ViewModel

    var arView: ARView { return self }
    var subscriptions = Set<AnyCancellable>()

    var originAnchor: AnchorEntity!
    var pov: AnchorEntity!
    
    var planeAnchor: AnchorEntity?

    init(frame: CGRect, viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        setupScene()
        setupEntities()
        setupSubscriptions()
    }
        
    func setupScene() {
        // Create an anchor at scene origin.
        originAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(originAnchor)
        
        // Add pov entity that follows the camera.
        pov = AnchorEntity(.camera)
        arView.scene.addAnchor(pov)
        
        // Setup world tracking and plane detection.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.renderOptions = [.disableDepthOfField, .disableMotionBlur]
        arView.session.run(configuration)
        
        // Enable mesh scene reconstruction.
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            configuration.sceneReconstruction = .mesh
        } else {
            print("❗️ARWorldTrackingConfiguration: Does not support sceneReconstruction.")
        }

        // Run configuration.
        arView.session.run(configuration)
        
        // Enable physics.
        arView.environment.sceneUnderstanding.options.insert(.physics)
    }

    
    // Define entities here.
    func setupEntities() {

    }

    
    // Define subscriptions here.
    func setupSubscriptions() {
        // Process UI signals.
        viewModel.uiSignal.sink { [weak self] signal in
            guard let self else { return }

            switch signal {
            case .reset:
                resetScene()
            }
        }
        .store(in: &subscriptions)


        viewModel.$showDebug.sink { [weak self] showDebug in
            guard let self else { return }
            
            if showDebug {
                arView.debugOptions.insert(.showSceneUnderstanding)
            } else {
                arView.debugOptions.remove(.showSceneUnderstanding)
            }
        }
        .store(in: &subscriptions)

    }

    

    // Reset plane anchor and position entities.
    func resetScene() {
        // Reset plane anchor. //
        planeAnchor?.removeFromParent()
        planeAnchor = nil
        
//        planeAnchor = AnchorEntity(plane: [.horizontal])
        planeAnchor = AnchorEntity(.plane([.vertical, .horizontal],
                              classification: [.wall, .floor, .ceiling],
                               minimumBounds: [1.0, 1.0]))
        
        arView.scene.addAnchor(planeAnchor!)
    }
}
