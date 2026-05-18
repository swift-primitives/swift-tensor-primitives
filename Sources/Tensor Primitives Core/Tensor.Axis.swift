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
    /// Namespace for tensor axis identity and protocol.
    ///
    /// At L1, the axis namespace hosts only `Tensor.Axis.Protocol` (the
    /// witness protocol for named-axis types) and supporting machinery. The
    /// `Tensor.Named<Element, repeat each Axis>` value type lives in the
    /// separate `Tensor Named Primitives` variant target so callers who do
    /// not need SE-0398 variadic-pack overhead don't pay for it.
    public enum Axis {}
}
