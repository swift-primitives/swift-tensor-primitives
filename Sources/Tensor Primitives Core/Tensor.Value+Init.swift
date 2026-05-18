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

extension Tensor.Value {
    /// The runtime shape of this tensor.
    @inlinable
    public var shape: Tensor.Shape<Rank> {
        _shape
    }

    /// The runtime strides of this tensor.
    @inlinable
    public var strides: Tensor.Strides<Rank> {
        _strides
    }
}
