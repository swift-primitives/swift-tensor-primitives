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

extension Tensor.Index {
    /// Errors describing an indexing failure condition.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The index position is out of bounds along the given axis.
        ///
        /// - Parameters:
        ///   - axis: The axis along which the index is out of range.
        ///   - position: The supplied position.
        ///   - bound: The cardinality bound (`shape.dims[axis]`).
        case outOfBounds(axis: Cardinal, position: Ordinal, bound: Cardinal)

        /// The index's rank does not match the tensor's rank.
        case rankMismatch(expected: Cardinal, actual: Cardinal)
    }
}
