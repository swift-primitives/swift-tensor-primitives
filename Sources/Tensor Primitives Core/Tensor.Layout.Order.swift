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

extension Tensor.Layout {
    /// Namespace for canonical contiguous layout orders.
    ///
    /// `Order` encodes the canonical row-major / column-major dichotomy as
    /// restricted-form layouts. Each variant carries a compile-time contiguity
    /// guarantee and a known stride pattern derived from the shape.
    ///
    /// - `Tensor.Layout.Order.Row` — C-order, last axis varies fastest.
    /// - `Tensor.Layout.Order.Column` — F-order, first axis varies fastest.
    ///
    /// The sibling type `Tensor.Layout.Strided` is the general-form layout
    /// admitting arbitrary per-axis strides without a contiguity guarantee.
    /// `Order` and `Strided` are siblings under `Tensor.Layout`: `Order` is
    /// restricted-form (named orders with statically-known stride patterns);
    /// `Strided` is general-form (arbitrary strides, used for transposes,
    /// broadcasts, and arbitrary slicing). `Strided` is intentionally NOT a
    /// member of `Order` — it is not a named order, it is the absence of one.
    public enum Order {}
}
