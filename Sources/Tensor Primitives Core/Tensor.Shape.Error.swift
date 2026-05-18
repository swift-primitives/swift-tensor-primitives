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

extension Tensor.Shape {
    /// Errors describing a shape-related failure condition.
    ///
    /// Per `[API-ERR-003]`, cases describe the failure condition (mismatch,
    /// arity error, zero rank), not recovery actions.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The supplied element count does not equal the product of shape dimensions.
        ///
        /// - Parameters:
        ///   - expected: The element count the shape requires (`Π dims`).
        ///   - actual: The element count actually supplied.
        case elementCountMismatch(expected: Cardinal, actual: Cardinal)

        /// The shape is rank-zero but a positive rank was expected.
        case unexpectedScalarShape

        /// A shape contains a zero dimension that the operation forbids.
        ///
        /// - Parameter axis: The axis at which the zero appears.
        case zeroDimensionForbidden(axis: Cardinal)
    }
}
