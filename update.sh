#!/bin/sh

set -e

REPO=realm/SwiftLint
NEW_NAME=SwiftLintBinary.artifactbundle.zip
VERSION=$(
  gh release list \
    --repo ${REPO} \
    --exclude-pre-releases \
    --limit 1 \
    --json tagName -q '.[0].tagName'
)

# Check if the version already exists as a tag
if git rev-parse "v${VERSION}" >/dev/null 2>&1; then
  echo "Version ${VERSION} already exists. No update needed."
  exit 0
fi

echo "${VERSION}"

ASSET_URL=$(gh api \
  repos/${REPO}/releases/tags/"${VERSION}" \
  --jq '.assets[] | select(.name=="'"${NEW_NAME}"'") | .browser_download_url')

echo "${ASSET_URL}"
curl -L -o "${NEW_NAME}" "${ASSET_URL}"

SUM=$(sha256sum ${NEW_NAME} | awk '{print $1}')
DOWNLOAD_URL="${ASSET_URL}"

PACKAGE=$(
  cat <<END
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
      url: "${DOWNLOAD_URL}",
      checksum: "${SUM}"
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

END
)

echo "$PACKAGE" >Package.swift
git add Package.swift
git commit -m "new Version ${VERSION}"
git tag -s -a "v${VERSION}" -m "v${VERSION}"
git push origin HEAD --tags

# git push origin HEAD
# echo ${VERSION} > version
# git add version
# git commit -m "new Version ${VERSION}"
# git checkout -b release-v${VERSION}

NOTES=$(
  cat <<END
SPM Plugin
\`\`\`
dependencies: [
.package(url: "https://github.com/exception7601/SwiftLint.git", from: "${VERSION}")
],

targets: [
.target(
  name: "MyTarget",
  plugins: [
  .plugin(name: "SwiftLintPlugin", package: "SwiftLint"),
  ]
  ),
]
\`\`\`
END
)

gh release create "v${VERSION}" --notes "${NOTES}"
echo "${NOTES}"
