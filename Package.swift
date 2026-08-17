// swift-tools-version: 6.3.3
import PackageDescription

let package = Package(
    name: "swift-tensor-primitives",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27"),
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
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-index-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-cardinal-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-ordinal-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-finite-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-affine-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-dimension-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-buffer-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-buffer-linear-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-storage-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-range-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-memory-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-numeric-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-algebra-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-error-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-format-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-sequence-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-vector-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-memory-heap-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-memory-allocation-primitives.git", branch: "main"),
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
                .product(name: "Buffer Linear Primitives", package: "swift-buffer-linear-primitives"),
                .product(name: "Storage Primitives", package: "swift-storage-primitives"),
                .product(name: "Range Primitives", package: "swift-range-primitives"),
                .product(name: "Memory Primitives", package: "swift-memory-primitives"),
                .product(name: "Memory Allocator Primitive", package: "swift-memory-allocation-primitives"),
                .product(name: "Memory Allocator Protocol Primitives", package: "swift-memory-allocation-primitives"),
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
            dependencies: [
                "Tensor Primitives Core",
                .product(name: "Memory Heap Primitives", package: "swift-memory-heap-primitives"),
            ]
        ),
        .target(
            name: "Tensor Named Primitives",
            dependencies: [
                "Tensor Primitives Core",
                .product(name: "Memory Heap Primitives", package: "swift-memory-heap-primitives"),
            ]
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
