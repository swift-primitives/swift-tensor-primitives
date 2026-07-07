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

extension Tensor.Storage {
    /// Zero-size witness marking a heap-backed owned storage policy.
    ///
    /// Tensors with this witness back their elements with `Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear`
    /// from `swift-buffer-primitives` — heap-allocated, exclusively-owned,
    /// `~Copyable` storage. This is the default.
    public struct Owned: Sendable {
        /// Creates the (zero-size) witness value.
        @inlinable
        public init() {}
    }
}
