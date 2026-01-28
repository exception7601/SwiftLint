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
      url: "https://github.com/realm/SwiftLint/releases/download/0.63.2/SwiftLintBinary.artifactbundle.zip",
      checksum: "12befab676fc972ffde2ec295d016d53c3a85f64aabd9c7fee0032d681e307e9"
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
