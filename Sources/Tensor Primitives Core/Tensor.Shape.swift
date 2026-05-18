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
    /// A compile-time-rank, runtime-dim shape vector.
    ///
    /// A tensor's shape names its per-axis cardinality. Rank is fixed at the
    /// type level via SE-0452 (value generics); per-axis sizes are runtime
    /// values stored as `Cardinal`.
    ///
    /// `Tensor.Shape<Rank>` is the value-type counterpart to NumPy's
    /// `ndarray.shape` tuple and ndarray's `IxN` types. Per the linear-index
    /// formula `offset = Σ strides[k] · index[k]`, the shape provides per-axis
    /// upper bounds; the corresponding `Tensor.Strides<Rank>` carries the
    /// signed displacements.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var dims = InlineArray<3, Cardinal>(repeating: Cardinal(0))
    /// dims[0] = Cardinal(2); dims[1] = Cardinal(3); dims[2] = Cardinal(4)
    /// let shape = Tensor.Shape<3>(dims)
    /// // shape (2, 3, 4) — total element count 2·3·4 = 24
    /// ```
    public struct Shape<let Rank: Int>: Copyable, Sendable {
        /// Per-axis cardinalities, indexed `0 ..< Rank`.
        public var dims: InlineArray<Rank, Cardinal>

        /// Creates a shape from the given per-axis cardinalities.
        ///
        /// - Parameter dims: Per-axis cardinalities. Element at position `k`
        ///   names axis `k`'s size.
        @inlinable
        public init(_ dims: InlineArray<Rank, Cardinal>) {
            self.dims = dims
        }
    }
}
