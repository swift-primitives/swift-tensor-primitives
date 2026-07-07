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

extension Tensor.Layout {
    /// Arbitrary-stride layout witness.
    ///
    /// A `Strided` tensor carries arbitrary per-axis strides; contiguity is
    /// not guaranteed. Views produced by transpose, broadcast, or arbitrary
    /// slicing carry this witness. Operations needing contiguous element
    /// access (raw buffer reinterpretation, BLAS calls) must check at the
    /// operation site or convert via copy.
    public struct Strided: _TensorLayoutProtocol {
        /// Creates the (zero-size) witness value.
        @inlinable
        public init() {}
    }
}

extension Tensor.Layout.Strided {
    /// A textual tag for diagnostics.
    @inlinable
    public static var tag: String { "Strided" }

    /// Whether this layout guarantees contiguous storage.
    @inlinable
    public static var isContiguous: Bool { false }
}
