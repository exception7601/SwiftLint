// swift-tools-version:5.9
import PackageDescription

let package = Package(

  name: "SwiftLint",
  platforms: [.macOS(.v13)],

  products: [

    .plugin(
      name: "SwiftLintPlugin",
      targets: ["SwiftLintPlugin"]
    )
  ],

  targets: [

    .binaryTarget(
      name: "SwiftLintBinary",
      url: "https://github.com/SwiftLint/releases/releases/download//SwiftLintBinary-macos.artifactbundle.zip",
      checksum: ""
    ),

    .plugin(
      name: "SwiftLintPlugin",
      capability: .buildTool(),
      dependencies: [
        .target(name: "SwiftLintBinary", condition: .when(platforms: [.macOS]))
      ]
    )

  ]
)
