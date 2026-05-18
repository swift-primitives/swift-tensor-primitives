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
    /// A compile-time-rank, signed per-axis stride vector.
    ///
    /// Strides express the per-axis element-count distance to advance the flat
    /// underlying buffer when stepping one position along that axis. Negative
    /// strides indicate reversed iteration; a stride of zero indicates a
    /// broadcast axis (the operand reads the same element repeatedly).
    ///
    /// Element-count strides (not byte-strides) follow ndarray and PyTorch;
    /// byte arithmetic is the responsibility of the storage type.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Row-major shape (2, 3, 4) → strides (12, 4, 1)
    /// var values = InlineArray<3, Affine.Discrete.Vector>(repeating: 0)
    /// values[0] = 12; values[1] = 4; values[2] = 1
    /// let strides = Tensor.Strides<3>(values)
    /// ```
    public struct Strides<let Rank: Int>: Copyable, Sendable {
        /// Per-axis signed strides, indexed `0 ..< Rank`.
        public var values: InlineArray<Rank, Affine.Discrete.Vector>

        /// Creates a stride vector from the given per-axis values.
        @inlinable
        public init(_ values: InlineArray<Rank, Affine.Discrete.Vector>) {
            self.values = values
        }
    }
}
