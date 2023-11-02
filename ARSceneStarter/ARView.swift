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

    // Origin anchor.
    var originAnchor: AnchorEntity!

    // POV anchor attached to anchor.
    var pov: AnchorEntity!

    // Custom entities.
    var testSphere: ModelEntity!
    var testBox: ModelEntity!
    var toyPlane: ModelEntity!
        
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
    
    // Call when view first loads.
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        setupScene()
        setupEntities()
        setupSubscriptions()
    }
        
    // Setup scene configuration.
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

    
    /// Define entities.
    func setupEntities() {
        // Attach test sphere to origin anchor.
        testSphere = makeSphereEntity(name: "sphere", radius: 0.05, color: .red)
        originAnchor.addChild(testSphere)

        // Attach test box to left of test sphere.
        testBox = makeBoxEntity(name: "box", width: 0.1, height: 0.1, depth: 0.1, imageName: "checker.png")
        testBox.position.x = -0.25
        testSphere.addChild(testBox)

        // Attach toy plane to right of test sphere.
        toyPlane = makeModelEntity(name: "plane", usdzModelName: "toy_biplane")
        toyPlane.animate(true)
        toyPlane.position.x = 0.25
        testSphere.addChild(toyPlane)
    }

    
    /// Define subscriptions. i.e. Listen to updates to viewModel.
    func setupSubscriptions() {
        /*
        // Called every frame.
        scene.subscribe(to: SceneEvents.Update.self) { [weak self] event in
            guard let self else { return }
            
            // Get camera position.
            let povPosition = pov.position(relativeTo: originAnchor)
            print(povPosition)
        }
        .store(in: &subscriptions)
         */
         

        // Process UI signals.
        viewModel.uiSignal.sink { [weak self] signal in
            guard let self else { return }

            switch signal {
            case .reset:
                resetScene()
            }
        }
        .store(in: &subscriptions)


        // Process change to showDebug state variable.
        viewModel.$showDebug.sink { [weak self] showDebug in
            guard let self else { return }
            
            if showDebug {
                arView.debugOptions.insert(.showSceneUnderstanding)
                arView.debugOptions.insert(.showWorldOrigin)
            } else {
                arView.debugOptions.remove(.showSceneUnderstanding)
                arView.debugOptions.remove(.showWorldOrigin)
            }
        }
        .store(in: &subscriptions)
    }

    
    /// Reset scene.
    func resetScene() {
        // Move test sphere and children in front of camera.
        testSphere.transform.matrix = pov.transformMatrix(relativeTo: originAnchor) * Transform(translation: [0, 0, -0.5]).matrix
    }
}
