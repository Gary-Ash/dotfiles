___FILEHEADER___

import ARKit
import CompositorServices
import SwiftUI

struct ImmersiveSpaceContent: CompositorContent {

    var appModel: AppModel

    var body: some CompositorContent {
        CompositorLayer(configuration: self) { @MainActor layerRenderer in
            Renderer.startRenderLoop(layerRenderer, appModel: appModel, arSession: ARKitSession())
        }
    }
}

extension ImmersiveSpaceContent: CompositorLayerConfiguration {
    func makeConfiguration(capabilities: LayerRenderer.Capabilities, configuration: inout LayerRenderer.Configuration) {
        let device = MTLCreateSystemDefaultDevice()!

        configuration.drawableRenderContextRasterSampleCount = device.rasterSampleCount

        if capabilities.drawableRenderContextSupportedStencilFormats.contains(.stencil8) {
            configuration.drawableRenderContextStencilFormat = .stencil8
        } else {
            configuration.drawableRenderContextStencilFormat = .depth32Float_stencil8
            configuration.depthFormat = .depth32Float_stencil8
        }

        let foveationEnabled = capabilities.supportsFoveation
        configuration.isFoveationEnabled = foveationEnabled

        let options: LayerRenderer.Capabilities.SupportedLayoutsOptions = foveationEnabled ? [.foveationEnabled] : []
        let supportedLayouts = capabilities.supportedLayouts(options: options)

        configuration.layout = supportedLayouts.contains(.layered) ? .layered : .dedicated

        configuration.supportsMTL4 = true
    }
}

@main
struct ___PACKAGENAME:identifier___App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        .windowStyle(.volumetric)

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveSpaceContent(appModel: appModel)
        }
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
    }
}