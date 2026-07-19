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

extension Tensor.Broadcast {
    /// Decomposes a row-major linear output index into a multi-axis
    /// position within `shape`.
    ///
    /// Inverse of `Tensor.Index.Position.linearize(strides:)` against
    /// `Tensor.Strides(rowMajor: shape)`: the last axis varies fastest, so
    /// `linearIndex` walks `shape` the same way a plain contiguous-buffer
    /// traversal would. A broadcast kernel uses this to recover the output
    /// coordinate for each step of its flat output loop; that coordinate is
    /// then linearized against each operand's own (possibly zero-strided)
    /// `strides(of:aligned:)` vector to find the operand's element offset.
    ///
    /// - Parameters:
    ///   - linearIndex: A row-major linear index in `0..<shape.count`.
    ///   - shape: The shape `linearIndex` is drawn from.
    /// - Returns: The per-axis position corresponding to `linearIndex` in
    ///   row-major order.
    /// - Precondition: `0 <= linearIndex < Int(bitPattern: shape.count)`.
    @inlinable
    public static func position<let Rank: Int>(
        ofLinearIndex linearIndex: Int,
        in shape: Tensor.Shape<Rank>
    ) -> Tensor.Index.Position<Rank> {
        var positions = InlineArray<Rank, Ordinal>(repeating: .zero)
        var remaining = linearIndex
        // Walk axes in reverse so the last axis is decoded fastest,
        // mirroring `Tensor.Strides.init(rowMajor:)` in
        // `Tensor.Strides+Order.swift`. Non-throwing, so stdlib
        // `Sequence.forEach` suffices.
        stride(from: Rank - 1, through: 0, by: -1).forEach { axis in
            let dim = Int(bitPattern: shape.dims[axis])
            positions[axis] = Ordinal(UInt(bitPattern: remaining % dim))
            remaining /= dim
        }
        return Tensor.Index.Position<Rank>(positions)
    }
}
