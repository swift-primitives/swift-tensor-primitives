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

public import Tensor_Primitives_Core

extension Tensor {
    /// Namespace for rank-erased tensors.
    ///
    /// The rank-erased family carries data-dependent dimensions whose rank
    /// cannot be expressed at the type level. Two inhabitants live here:
    /// - `Tensor.Dynamic.Shape` — rank-erased shape (per-axis cardinalities
    ///   in an array; the array's count IS the runtime rank).
    /// - `Tensor.Dynamic.Value<Element>` — rank-erased tensor value type.
    public enum Dynamic {}
}
