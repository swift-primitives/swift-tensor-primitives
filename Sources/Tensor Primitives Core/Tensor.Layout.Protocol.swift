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

/// Hoisted protocol backing `Tensor.Layout.Protocol`.
///
/// Per `[API-IMPL-009]`, the protocol is hoisted to module scope so the
/// declaring-module conformances (Order.Row / Order.Column / Strided) avoid the
/// self-referential cycle of `extension X: X.Protocol`.
public protocol _TensorLayoutProtocol: Sendable {
    /// A textual tag for diagnostics.
    static var tag: String { get }

    /// Whether values of this layout guarantee contiguous storage.
    static var isContiguous: Bool { get }
}

extension Tensor.Layout {
    /// Witness protocol for the `Layout` parameter of `Tensor<Element, Rank, Layout>`.
    ///
    /// Implemented by three zero-size witnesses: `Tensor.Layout.Order.Row`,
    /// `Tensor.Layout.Order.Column`, `Tensor.Layout.Strided`.
    public typealias `Protocol` = _TensorLayoutProtocol
}
