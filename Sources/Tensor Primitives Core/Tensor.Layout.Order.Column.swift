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
    /// Column-major (F-order) layout witness.
    ///
    /// In column-major layout the first axis varies fastest in memory. For
    /// shape `(d₀, d₁, d₂)` the strides are `(1, d₀, d₀ · d₁)`. This is the
    /// default of Fortran and Eigen.
    public struct Column: _TensorLayoutProtocol {
        @inlinable
        public init() {}
    }
}

extension Tensor.Layout.Order.Column {
    @inlinable
    public static var tag: String { "Column" }

    @inlinable
    public static var isContiguous: Bool { true }
}
