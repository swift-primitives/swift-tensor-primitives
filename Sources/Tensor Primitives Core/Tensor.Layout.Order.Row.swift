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

extension Tensor.Layout.Order {
    /// Row-major (C-order) layout witness.
    ///
    /// In row-major layout the last axis varies fastest in memory. For shape
    /// `(d₀, d₁, d₂)` the strides are `(d₁ · d₂, d₂, 1)` so element
    /// `(i, j, k)` lives at offset `i · d₁ · d₂ + j · d₂ + k`. This is the
    /// default of NumPy, PyTorch, and ndarray.
    public struct Row: _TensorLayoutProtocol {
        @inlinable
        public init() {}
    }
}

extension Tensor.Layout.Order.Row {
    @inlinable
    public static var tag: String { "Row" }

    @inlinable
    public static var isContiguous: Bool { true }
}
