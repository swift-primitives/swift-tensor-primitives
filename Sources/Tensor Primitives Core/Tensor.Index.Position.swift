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
    /// A multi-axis index position into a tensor of compile-time rank.
    ///
    /// `Tensor.Index.Position<Rank>` carries a per-axis ordinal position.
    /// Bounds are validated against an accompanying `Tensor.Shape<Rank>` at
    /// the operation site; the position itself is structurally unconstrained
    /// so the same shape can be used with multiple tensors of equal rank.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var positions = InlineArray<3, Ordinal>(repeating: Ordinal(0))
    /// positions[1] = Ordinal(2); positions[2] = Ordinal(1)
    /// let i = Tensor.Index.Position<3>(positions)
    /// // Index into a rank-3 tensor at coordinates (0, 2, 1).
    /// ```
    public struct Position<let Rank: Int>: Copyable, Sendable {
        /// Per-axis position values.
        public var positions: InlineArray<Rank, Ordinal>

        /// Creates a multi-axis index position.
        @inlinable
        public init(_ positions: InlineArray<Rank, Ordinal>) {
            self.positions = positions
        }
    }
}
