___FILEHEADER___

import SwiftUI
import RealityKit

struct ContentView: View {

    var boxEntity = Entity()

    var body: some View {
        ZStack {
            RealityView { content in
                createGameScene(content)
            }

            // Add button to tap the cube.
            VStack {
                Spacer()
                Button(action: {
                    try? spinEntity(boxEntity)
                }, label: {
                    Text("Select to spin the cube!")
                })
            }.padding()
        }
    }

    /// Creates a game scene and adds it to the view content.
    ///
    /// - Parameter content: The active content for this RealityKit game.
    fileprivate func createGameScene(_ content: any RealityViewContentProtocol) {
        let boxSize: SIMD3<Float> = [0.2, 0.2, 0.2]
        // A component that shows a red box model.
        let boxModel = ModelComponent(
            mesh: .generateBox(size: boxSize),
            materials: [SimpleMaterial(color: .red, isMetallic: true)]
        )

        // A component that sets the collision shape.
        let boxCollision = CollisionComponent(shapes: [.generateBox(size: boxSize)])

        // A component that stores spin information.
        let spinComponent = SpinComponent()

        // Set all the entity's components.
        boxEntity.components.set([
            boxModel, boxCollision, spinComponent
        ])

        // Add the entity to the RealityView content.
        content.add(boxEntity)

        // Add a perspective camera to the scene.
        let camera = Entity()
        camera.components.set(PerspectiveCameraComponent())
        content.add(camera)

        // Set the camera position and orientation.
        let cameraLocation: SIMD3<Float> = [1, 1, 2]
        camera.look(at: .zero, from: cameraLocation, relativeTo: nil)
    }

    /// Spins an entity around the y-axis.
    /// - Parameter entity: The entity to spin.
    func spinEntity(_ entity: Entity) throws {
        // Get the entity's spin component.
        guard let spinComponent = entity.components[SpinComponent.self]
        else { return }

        // Create a spin action that makes one revolution
        // around the axis from the component.
        let spinAction = SpinAction(revolutions: 1, localAxis: spinComponent.spinAxis)

        // Create a one second animation that spins an entity.
        let spinAnimation = try AnimationResource.makeActionAnimation(
            for: spinAction,
            duration: 1,
            bindTarget: .transform
        )

        // Play the animation that spins the entity.
        entity.playAnimation(spinAnimation)
    }
}

#Preview {
    ContentView()
}
