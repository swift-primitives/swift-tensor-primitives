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

extension Tensor.Slice {
    /// A multi-axis slice specification.
    ///
    /// Each axis position carries a `Tensor.Slice.Axis` describing how to
    /// extract that axis: a single position, a contiguous range, the full
    /// axis, or a new-axis insertion.
    public struct Specification<let Rank: Int>: Copyable, Sendable {
        /// Per-axis slice specifications.
        public var axes: InlineArray<Rank, Tensor.Slice.Axis>

        /// Creates a slice specification.
        @inlinable
        public init(_ axes: InlineArray<Rank, Tensor.Slice.Axis>) {
            self.axes = axes
        }
    }
}
