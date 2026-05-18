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

extension Tensor.Value where Element: Copyable {
    /// Returns a transposed tensor for rank-2 inputs.
    ///
    /// Transpose swaps axes 0 and 1, producing a tensor with shape
    /// `(d₁, d₀)`. This implementation materializes a copy in row-major order
    /// so the result is contiguous. (A zero-copy view-based transpose lives
    /// in `Tensor.View.transposed()` on the view side.)
    ///
    /// This rank-2 specialization is the only one provided at L1; rank-N
    /// general permutation lives at higher layers per the SE-0452 arithmetic
    /// gap.
    @inlinable
    public func transposed() -> Tensor.Value<Element, Rank, Tensor.Layout.Strided>
    where Rank == 2 {
        var newDims = InlineArray<2, Cardinal>(repeating: .zero)
        newDims[0] = _shape.dims[1]
        newDims[1] = _shape.dims[0]
        let newShape = Tensor.Shape<2>(newDims)
        let count = newShape.count
        var newStorage = Buffer<Element>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        // Stride math at the L1 boundary: linearization formula
        // `srcOffset = newJ · stride0 + newI · stride1` is dimensional-mixing
        // (`Ordinal × Vector`) that has no typed-system expression per
        // [INFRA-200]. The bodies are non-throwing (the index advance is via
        // `_unchecked` construction), so stdlib `Range.forEach` suffices.
        let rows = Int(bitPattern: newDims[0])
        let cols = Int(bitPattern: newDims[1])
        let stride0 = Int(bitPattern: _strides.values[0])
        let stride1 = Int(bitPattern: _strides.values[1])
        (0..<rows).forEach { newI in
            (0..<cols).forEach { newJ in
                // The new (newI, newJ) maps to original (newJ, newI).
                // srcOffset is non-negative by construction (newI, newJ ≥ 0 and
                // strides ≥ 0 for a base tensor), so `_unchecked` expresses the
                // static-guarantee directly without a `try!` ceremony.
                let srcOffset = newJ * stride0 + newI * stride1
                let idx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: srcOffset)))
                newStorage.append(_storage[idx])
            }
        }
        let newStrides = Tensor.Strides<2>(rowMajor: newShape)
        return Tensor.Value<Element, 2, Tensor.Layout.Strided>(
            shape: newShape,
            strides: newStrides,
            storage: newStorage
        )
    }
}
