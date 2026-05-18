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
    /// Namespace for tensor storage policy witnesses.
    ///
    /// Storage witnesses parameterize how a tensor's element buffer is laid
    /// out. Two are provided at L1:
    /// - `Tensor.Storage.Owned` — heap-backed via `Buffer.Linear<Element>`.
    /// - `Tensor.Storage.Aligned` — page-aligned for GPU-bridge / direct-I/O
    ///   preparation via `Buffer.Aligned<UInt8>`.
    public enum Storage {}
}
