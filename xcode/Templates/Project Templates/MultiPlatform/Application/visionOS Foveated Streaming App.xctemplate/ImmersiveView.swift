___FILEHEADER___

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel

    @State private var dragOffset: Size3D = .zero
    @State private var prevOffset: Size3D = .zero

    @State private var entity: ModelEntity = {
        var blue = UnlitMaterial(color: .init(red: 0, green: 0, blue: 1, alpha: 1))
        blue.blending = .transparent(opacity: 0.5)

        let radius: Float = 0.025
        let entity = ModelEntity(mesh: .generateSphere(radius: radius), materials: [blue])

        entity.components.set(InputTargetComponent())
        entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: radius)]))

        return entity
    }()

    var body: some View {
        RealityView { content in
            content.add(entity)
        }
        .offset(CGSize(width: dragOffset.width, height: dragOffset.height))
        .gesture(
            DragGesture()
                .targetedToEntity(entity)
                .onChanged { dragOffset = prevOffset + $0.translation3D }
                .onEnded { _ in prevOffset = dragOffset }
        )
        .onAppear {
            appModel.immersiveSpaceState = .open
        }
        .onDisappear {
            appModel.immersiveSpaceState = .closed
        }
    }
}
