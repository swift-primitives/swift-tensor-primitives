// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Tensor {
    /// Namespace for reshape operations and their errors.
    public enum Reshape {}
}

extension Tensor.Reshape {
    /// Reshape failure cases.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The new shape's element count differs from the original.
        ///
        /// - Parameters:
        ///   - from: The number of elements in the source shape.
        ///   - to: The number of elements in the requested shape.
        case productNotPreserved(from: Cardinal, to: Cardinal)

        /// The requested view-only reshape is not stride-compatible with
        /// the source layout.
        case notContiguous
    }
}
