# README

This project is for generating the CompositorServices template files, specifically:
- visionOS: ./Applications/IDE/PlugIns/Xcode3ProjectSupport/Templates/Project Templates/visionOS/Application/App.xctemplate
    - primarySceneType/<Volume/Window>/secondarySceneType/<Metal/Metal4>/immersiveSpaceStyle/<Full/Mixed/Progressive>/App.swift
    - secondarySceneType/<Metal/Metal4>/<Mixed-Full/Progressive>/Renderer.swift
- macOS: ./Applications/IDE/PlugIns/Xcode3ProjectSupport/Templates/Project Templates/macOS/Application/macOS Spatial Rendering.xctemplate

The Everything target builds all of the possibly combinations of the files to ensure they compile, and any modifications will be propagated to the corresponding files.

Do _**NOT**_ edit the templates directly, this project should be the only way to generate the templates

## Notes:
- When adding a new `#if` condition for the templates, add the new line inside the condition rather than before the condition.
- Don't add comments to the code that you don't want to be public -- they currently aren't stripped from the template.
- All new compilation conditions for templates should start with `CP_TEMPLATE_` otherwise won't be filtered in the template.
- Parsing generation doesn't support `!CP_TEMPLATE_XXX` so always do `#if/#else` if `!` is required.
- `// CP_TEMPLATE_DELETE_NEXT` is a special comment keyword which will remove that line as well as the next -- this enables hacks required for building the target but not required for the template, use sparingly.

## `CP_TEMPLATE` Compilation Conditions

- `CP_TEMPLATE_VOLUME`

- `CP_TEMPLATE_MTL4`

- `CP_TEMPLATE_FULL`
- `CP_TEMPLATE_MIXED`
- `CP_TEMPLATE_PROGRESSIVE`

- `CP_TEMPLATE_MACOS`
