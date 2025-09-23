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
      url: "https://github.com/realm/SwiftLint/releases/download/0.61.0/SwiftLintBinary.artifactbundle.zip",
      checksum: "b765105fa5c5083fbcd35260f037b9f0d70e33992d0a41ba26f5f78a17dc65e7"
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
