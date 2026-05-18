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

extension Tensor.Dynamic {
    /// A rank-erased shape carrying runtime-discoverable per-axis cardinalities.
    ///
    /// The runtime rank is `dims.count`. The element-count product
    /// `dims.reduce(Cardinal(1), *)` determines the tensor's storage size.
    public struct Shape: Copyable, Sendable, Equatable {
        /// Per-axis cardinalities; the count determines the runtime rank.
        public var dims: [Cardinal]

        /// Creates a rank-erased shape.
        @inlinable
        public init(_ dims: [Cardinal]) {
            self.dims = dims
        }
    }
}
