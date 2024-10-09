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
      url: "https://github.com/realm/SwiftLint/releases/download/0.57.0/SwiftLintBinary-macos.artifactbundle.zip",
      checksum: "a1bbafe57538077f3abe4cfb004b0464dcd87e8c23611a2153c675574b858b3a"
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
