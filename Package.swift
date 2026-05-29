// swift-tools-version: 6.3.1
import PackageDescription

let package = Package(
    name: "swift-tensor-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Tensor Primitives",
            targets: ["Tensor Primitives"]
        ),
        .library(
            name: "Tensor Dynamic Primitives",
            targets: ["Tensor Dynamic Primitives"]
        ),
        .library(
            name: "Tensor Named Primitives",
            targets: ["Tensor Named Primitives"]
        ),
        .library(
            name: "Tensor Primitives Test Support",
            targets: ["Tensor Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-tagged-primitives"),
        .package(path: "../swift-index-primitives"),
        .package(path: "../swift-cardinal-primitives"),
        .package(path: "../swift-ordinal-primitives"),
        .package(path: "../swift-finite-primitives"),
        .package(path: "../swift-affine-primitives"),
        .package(path: "../swift-dimension-primitives"),
        .package(path: "../swift-buffer-primitives"),
        .package(path: "../swift-storage-primitives"),
        .package(path: "../swift-memory-primitives"),
        .package(path: "../swift-numeric-primitives"),
        .package(path: "../swift-algebra-primitives"),
        .package(path: "../swift-error-primitives"),
        .package(path: "../swift-format-primitives"),
        .package(path: "../swift-sequence-primitives"),
        .package(path: "../swift-vector-primitives"),
    ],
    targets: [

        // MARK: - Core
        .target(
            name: "Tensor Primitives Core",
            dependencies: [
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Index Primitives", package: "swift-index-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Ordinal Primitives", package: "swift-ordinal-primitives"),
                .product(name: "Finite Primitives", package: "swift-finite-primitives"),
                .product(name: "Affine Primitives", package: "swift-affine-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
                .product(name: "Buffer Primitives", package: "swift-buffer-primitives"),
                .product(name: "Storage Primitives", package: "swift-storage-primitives"),
                .product(name: "Memory Primitives", package: "swift-memory-primitives"),
                .product(name: "Numeric Primitives", package: "swift-numeric-primitives"),
                .product(name: "Algebra Ring Primitives", package: "swift-algebra-primitives"),
                .product(name: "Error Primitives", package: "swift-error-primitives"),
                .product(name: "Format Primitives", package: "swift-format-primitives"),
                .product(name: "Sequence Primitives", package: "swift-sequence-primitives"),
                .product(name: "Vector Primitives", package: "swift-vector-primitives"),
            ]
        ),

        // MARK: - Variants
        .target(
            name: "Tensor Dynamic Primitives",
            dependencies: ["Tensor Primitives Core"]
        ),
        .target(
            name: "Tensor Named Primitives",
            dependencies: ["Tensor Primitives Core"]
        ),

        // MARK: - Umbrella
        .target(
            name: "Tensor Primitives",
            dependencies: [
                "Tensor Primitives Core",
                "Tensor Dynamic Primitives",
                "Tensor Named Primitives",
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Tensor Primitives Test Support",
            dependencies: [
                "Tensor Primitives",
                .product(name: "Buffer Primitives Test Support", package: "swift-buffer-primitives"),
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
        .testTarget(
            name: "Tensor Primitives Tests",
            dependencies: [
                "Tensor Primitives",
                "Tensor Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
