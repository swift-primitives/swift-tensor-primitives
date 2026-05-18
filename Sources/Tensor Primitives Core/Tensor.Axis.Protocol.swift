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

/// Hoisted protocol backing `Tensor.Axis.Protocol`.
///
/// Per `[API-IMPL-009]`, generic types referenced via a nested `Protocol`
/// typealias require the protocol itself to be hoisted to module scope so the
/// declaring-module conformance avoids the self-referential cycle.
/// Consumer modules use the `Tensor.Axis.Protocol` typealias path.
public protocol _TensorAxisProtocol {
    /// The compile-time-known cardinality of this axis.
    static var size: Int { get }
}

extension Tensor.Axis {
    /// Witness protocol for named-axis types in `Tensor.Named`.
    ///
    /// An axis type conforms to `Tensor.Axis.Protocol` by exposing a static
    /// `size: Int` naming its compile-time cardinality. The Dex-style overlay
    /// `Tensor.Named<Element, repeat each Axis>` consumes the protocol via
    /// SE-0398 variadic generics; see the `Tensor Named Primitives` target.
    public typealias `Protocol` = _TensorAxisProtocol
}
