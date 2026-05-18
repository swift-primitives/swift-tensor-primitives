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
    /// Namespace for tensor memory layout witnesses.
    ///
    /// Layout witnesses are zero-size phantom types that participate as the
    /// `Layout` generic parameter on `Tensor<Element, Rank, Layout>`. The
    /// witness drives layout-specific behavior at compile time without any
    /// runtime cost. Three witnesses are provided:
    /// - `Tensor.Layout.Order.Row` — C-order, last axis fastest.
    /// - `Tensor.Layout.Order.Column` — F-order, first axis fastest.
    /// - `Tensor.Layout.Strided` — arbitrary stride, no contiguity guarantee.
    public enum Layout {}
}
