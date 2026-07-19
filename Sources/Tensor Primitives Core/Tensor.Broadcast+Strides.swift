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
    /// Computes the stride vector an operand of shape `shape` must use while
    /// its buffer is read across the broadcast-aligned `aligned` output
    /// shape produced by `align(_:_:)`.
    ///
    /// Every axis where `shape` and `aligned` agree keeps the operand's own
    /// natural row-major stride for that axis. Every axis where `shape`
    /// carries length 1 while `aligned` carries a larger length is
    /// "stretched": the operand has only one element along that axis, so
    /// every output position along it must read the SAME element — the
    /// stride is forced to zero (zero-stride read repetition) instead of
    /// the operand's natural row-major stride, which would otherwise walk
    /// past the end of the smaller buffer as soon as the aligned axis
    /// exceeds the operand's own length.
    ///
    /// - Parameters:
    ///   - shape: The operand's own (pre-broadcast) shape.
    ///   - aligned: The unified output shape returned by `align(_:_:)` for
    ///     this operand and its broadcast partner.
    /// - Returns: A stride vector of the same rank as `shape`/`aligned`,
    ///   safe to linearize (`Tensor.Index.Position.linearize(strides:)`)
    ///   against any position drawn from the aligned iteration space.
    /// - Precondition: `shape` and `aligned` were produced together by
    ///   `align(_:_:)` (or satisfy the same per-axis compatibility) — every
    ///   axis of `shape` is either equal to the corresponding axis of
    ///   `aligned` or exactly `.one`.
    @inlinable
    public static func strides<let Rank: Int>(
        of shape: Tensor.Shape<Rank>,
        aligned: Tensor.Shape<Rank>
    ) -> Tensor.Strides<Rank> {
        var strides = Tensor.Strides<Rank>(rowMajor: shape)
        // Non-throwing per-axis walk: no typed-throws closure in play, so
        // stdlib `Sequence.forEach` resolves directly (see the [API-ERR-005]
        // note in `Tensor.Broadcast+Align.swift` for the throwing-closure
        // counterpart that instead routes through the institute `Property`
        // accessor).
        (0..<Rank).forEach { axis in
            if shape.dims[axis] == .one && aligned.dims[axis] != .one {
                strides.values[axis] = .zero
            }
        }
        return strides
    }
}
