___FILEHEADER___

import ARKit
import CompositorServices
import SwiftUI

struct ImmersiveSpaceContent: CompositorContent {
    #if CP_TEMPLATE_MACOS

    @Environment(\.remoteDeviceIdentifier) private var remoteDeviceIdentifier
    #endif

    var appModel: AppModel

    var body: some CompositorContent {
        CompositorLayer(configuration: self) { @MainActor layerRenderer in
            #if CP_TEMPLATE_MACOS
            Renderer.startRenderLoop(layerRenderer, appModel: appModel, arSession: .init(device: remoteDeviceIdentifier!))
            #else
            Renderer.startRenderLoop(layerRenderer, appModel: appModel, arSession: ARKitSession())
            #endif
        }
    }
}

extension ImmersiveSpaceContent: CompositorLayerConfiguration {
    func makeConfiguration(capabilities: LayerRenderer.Capabilities, configuration: inout LayerRenderer.Configuration) {
        #if CP_TEMPLATE_PROGRESSIVE
        let device = MTLCreateSystemDefaultDevice()!

        configuration.drawableRenderContextRasterSampleCount = device.rasterSampleCount

        if capabilities.drawableRenderContextSupportedStencilFormats.contains(.stencil8) {
            configuration.drawableRenderContextStencilFormat = .stencil8
        } else {
            configuration.drawableRenderContextStencilFormat = .depth32Float_stencil8
            configuration.depthFormat = .depth32Float_stencil8
        }

        #endif
        let foveationEnabled = capabilities.supportsFoveation
        configuration.isFoveationEnabled = foveationEnabled

        let options: LayerRenderer.Capabilities.SupportedLayoutsOptions = foveationEnabled ? [.foveationEnabled] : []
        let supportedLayouts = capabilities.supportedLayouts(options: options)

        configuration.layout = supportedLayouts.contains(.layered) ? .layered : .dedicated
        #if CP_TEMPLATE_MTL4

        configuration.supportsMTL4 = true
        #endif
    }
}

@main
// CP_TEMPLATE_DELETE_NEXT
/* Hack to compile b/c ___PACKAGENAME:identifier___ is invalid struct name but required for templates
struct ___PACKAGENAME:identifier___App: App {
// CP_TEMPLATE_DELETE_NEXT
 */
// CP_TEMPLATE_DELETE_NEXT
struct CompositorServicesXcodeTemplateApp: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
        #if CP_TEMPLATE_VOLUME
        .windowStyle(.volumetric)
        #endif

        #if CP_TEMPLATE_MACOS
        RemoteImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveSpaceContent(appModel: appModel)
        }
        #if CP_TEMPLATE_FULL
        .immersionStyle(selection: .constant(.full), in: .full)
        #endif
        #if CP_TEMPLATE_PROGRESSIVE
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
        #endif
        #else
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveSpaceContent(appModel: appModel)
        }
        #if CP_TEMPLATE_FULL
        .immersionStyle(selection: .constant(.full), in: .full)
        #endif
        #if CP_TEMPLATE_MIXED
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        #endif
        #if CP_TEMPLATE_PROGRESSIVE
        .immersionStyle(selection: .constant(.progressive), in: .progressive)
        #endif
        #endif
    }
}
