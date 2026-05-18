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
    /// Namespace for tensor slice types.
    ///
    /// Inhabitants:
    /// - `Tensor.Slice.Specification<Rank>` — a multi-axis slice specification.
    /// - `Tensor.Slice.Axis` — per-axis slice variants (full, range, single,
    ///   newAxis) mirroring NumPy's slicing operators.
    /// - `Tensor.Slice.Error` — typed errors raised on invalid ranges.
    public enum Slice {}
}
