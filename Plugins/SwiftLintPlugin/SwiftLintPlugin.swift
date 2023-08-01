import Foundation
import PackagePlugin

@main
struct SwiftLintPlugin: BuildToolPlugin {

  private func packageDirectory() -> URL {
    let fileURL = URL(fileURLWithPath: #file)
    let packageURL = fileURL
      // Remove Plugin
      .deletingLastPathComponent()
      // Remove Target
      .deletingLastPathComponent()
      // Remove FileName
      .deletingLastPathComponent()
    return packageURL
  }

  func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
    guard let sourceTarget = target as? SourceModuleTarget else {
      return []
    }

    let swiftLint = try context.tool(named: "swiftlint")
    let swiftFiles = sourceTarget.sourceFiles(withSuffix: "swift").map(\.path.string)
    let pathConfig = "\(packageDirectory().path)/.swiftlint.yml"

    var arguments = [
      "lint",
      "--quiet",
      "--force-exclude",
      "--config", pathConfig,
      "--cache-path", "\(context.pluginWorkDirectory)",
    ] + swiftFiles

    arguments += []

    return [
      .prebuildCommand(
        displayName: "SwiftLint",
        executable: swiftLint.path,
        arguments: arguments,
        outputFilesDirectory: context.pluginWorkDirectory.appending("Output")
      )
    ]
  }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftLintPlugin: XcodeBuildToolPlugin {
  func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
    let inputFilePaths = target.inputFiles
      .filter { $0.type == .source && $0.path.extension == "swift" }
      .map(\.path.string)
    let swiftLint = try context.tool(named: "swiftlint")
    let pathConfig = "\(packageDirectory().path)/.swiftlint.yml"

    return [
      .prebuildCommand(
        displayName: "SwiftLint",
        executable: swiftLint.path,
        arguments: [
          "lint",
          "--quiet",
          "--force-exclude",
          "--cache-path", "\(context.pluginWorkDirectory)",
          "--config", pathConfig
        ] + inputFilePaths,
        outputFilesDirectory: context.pluginWorkDirectory.appending("Output")
      )
    ]
  }
}
#endif
