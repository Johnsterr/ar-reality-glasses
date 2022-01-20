//
//  ContentView.swift
//  AR Reality Glasses
//
//  Created by Евгений Пашко on 20.01.2022.
//

import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func createBox() -> Entity {
        // Create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        
        // Create entity based on mesh
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    func createCircle(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        // Create circle mesh
        let circle = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // Create material
        let material = SimpleMaterial(color: .gray, isMetallic: false)
        
        // Create entity
        let circleEntity = ModelEntity(mesh: circle, materials: [material])
        circleEntity.position = SIMD3(x, y, z)
        circleEntity.scale.x = 1.1
        circleEntity.scale.z = 0.01
        
        return circleEntity
    }
    
    func createSphere(x: Float = 0, y: Float = 0, z: Float = 0, color: UIColor = .orange, radius: Float = 1) -> Entity {
        // Create sphere mesh
        let sphere = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, isMetallic: true)
        
        // Create sphere entity
        let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
        sphereEntity.position = SIMD3(x, y, z)
        
        return sphereEntity
    }
    
    func makeUIView(context: Context) -> ARView {
        // Create ARView
        let arView = ARView(frame: .zero)
        
        // Check that face tracking configuration is supported
        guard ARFaceTrackingConfiguration.isSupported else {
            print(#line, #function, "Sorry, face tracking is not supported by your device")
            return arView
        }
        
        // Create face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run face tracking session
        arView.session.run(configuration, options: [])
        
        // Create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        // Add box to the face anchor
        faceAnchor.addChild(createCircle(x: 0.035, y: 0.025, z: 0.058))
        faceAnchor.addChild(createCircle(x: -0.035, y: 0.025, z: 0.058))
        faceAnchor.addChild(createSphere(z: 0.058, radius: 0.025))
        
        // Add face anchor to the scene
        arView.scene.anchors.append(faceAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
