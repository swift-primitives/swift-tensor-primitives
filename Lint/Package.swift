// swift-tools-version: 6.3.1

// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-tensor-primitives open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-tensor-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

// Lint executable — consumer of the three-tier rules hierarchy
// (swift-primitives-linter-rules → swift-institute-linter-rules →
// swift-linter-rules). One bundle, one engine call. New rules added at
// any tier propagate here on the next dependency-resolution; this file
// does not need editing.

import PackageDescription

let package = Package(
    name: "Lint",
    platforms: [
        .macOS(.v26),
    ],
    products: [
        .executable(
            name: "Lint",
            targets: ["Lint"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-linter.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-primitives-linter-rules.git", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "Lint",
            dependencies: [
                .product(name: "Linter", package: "swift-linter"),
                .product(name: "Linter Primitives Rules", package: "swift-primitives-linter-rules"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
