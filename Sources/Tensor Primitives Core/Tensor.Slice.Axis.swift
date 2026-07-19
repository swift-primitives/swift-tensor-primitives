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
    /// A per-axis slice specification.
    ///
    /// Mirrors NumPy's per-axis slicing variants: full-axis (`:`), range
    /// (`a:b`), single position (drops the axis), or new-axis insertion
    /// (`np.newaxis`).
    public enum Axis: Copyable, Sendable, Equatable {
        /// Slice the entire axis (NumPy `:`).
        case full

        /// Slice a contiguous range `[start, end)` along the axis.
        case range(start: Ordinal, end: Ordinal)

        /// Take a single position along the axis.
        ///
        /// The axis is dropped from the resulting view.
        case single(Ordinal)

        /// Insert a new axis of size 1 at this position (NumPy `np.newaxis`).
        case newAxis
    }
}
