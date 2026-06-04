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
    /// Zero-size witness marking a page-aligned storage policy.
    ///
    /// Tensors with this witness back their elements with `Memory.Aligned`
    /// from `swift-memory-aligned-primitives` — page-aligned raw-byte storage. Use
    /// when the element buffer must satisfy a hard alignment guarantee for
    /// direct I/O, GPU bridging, or SIMD-aligned access.
    public struct Aligned: Sendable {
        @inlinable
        public init() {}
    }
}
