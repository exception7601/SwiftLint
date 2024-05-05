import Foundation
import PackagePlugin

extension Path {
  var directoryContainsConfigFile: Bool {
    FileManager.default.fileExists(atPath: "\(self)/.swiftlint.yml")
  }

  var depth: Int {
    URL(fileURLWithPath: "\(self)").pathComponents.count
  }

  func isDescendant(of path: Path) -> Bool {
    "\(self)".hasPrefix("\(path)")
  }

  func resolveWorkingDirectory(in directory: Path) throws -> Path {
    guard "\(self)".hasPrefix("\(directory)") else {
      throw SwiftLintBuildToolPluginError.pathNotInDirectory(path: self, directory: directory)
    }

    let path: Path? = sequence(first: self) { path in
      let path: Path = path.removingLastComponent()
      guard "\(path)".hasPrefix("\(directory)") else {
        return nil
      }
      return path
    }
      .reversed()
      .first(where: \.directoryContainsConfigFile)

    return path ?? directory
  }
}

enum SwiftLintBuildToolPluginError: Error, CustomStringConvertible {
    case pathNotInDirectory(path: Path, directory: Path)
    case swiftFilesNotInProjectDirectory(Path)
    case swiftFilesNotInWorkingDirectory(Path)

    var description: String {
        switch self {
        case let .pathNotInDirectory(path, directory):
            "Path '\(path)' is not in directory '\(directory)'."
        case let .swiftFilesNotInProjectDirectory(directory):
            "Swift files are not in project directory '\(directory)'."
        case let .swiftFilesNotInWorkingDirectory(directory):
            "Swift files are not in working directory '\(directory)'."
        }
    }
}
