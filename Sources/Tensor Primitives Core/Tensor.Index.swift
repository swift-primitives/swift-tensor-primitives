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
    /// Namespace for tensor indexing types.
    ///
    /// Two inhabitants: `Tensor.Index.Position<Rank>` (a typed multi-axis
    /// position) and `Tensor.Index.Error` (typed errors raised on out-of-bounds
    /// or rank-mismatch).
    public enum Index {}
}
