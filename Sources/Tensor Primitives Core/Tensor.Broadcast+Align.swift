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
    /// Unifies two equal-rank shapes per NumPy trailing-dim alignment.
    ///
    /// For each axis, the unified length is the larger of the two operands'
    /// lengths when one operand has length 1 (the unit operand broadcasts);
    /// otherwise the lengths must be equal.
    ///
    /// Rank-mismatched alignment (prepending implicit length-1 axes) is the
    /// responsibility of the caller via `Tensor.reshape(_:)` — this primitive
    /// expects equal rank to keep the type-level rank explicit.
    ///
    /// - Parameters:
    ///   - lhs: Left operand's shape.
    ///   - rhs: Right operand's shape.
    /// - Returns: The unified shape.
    /// - Throws: `Tensor.Broadcast.Error.incompatibleShapes` on per-axis
    ///   mismatch where neither operand carries length 1.
    @inlinable
    public static func align<let Rank: Int>(
        _ lhs: Tensor.Shape<Rank>,
        _ rhs: Tensor.Shape<Rank>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Shape<Rank> {
        var dims = InlineArray<Rank, Cardinal>(repeating: .zero)
        // `forEach` is routed through the institute's `Property` accessor
        // on `Swift.Range` (see `Swift.Range+ForEach.swift` in
        // `swift-vector-primitives`); typed-throws closures select the
        // Property path while non-throwing call sites continue to use
        // stdlib's inherited `Sequence.forEach`. Preserves `throws(E)` past
        // the closure boundary per `[API-ERR-005]` and climbs the iteration
        // ladder per `[IMPL-033]`.
        try (0..<Rank).forEach { (axis: Int) throws(Tensor.Broadcast.Error) in
            let a = lhs.dims[axis]
            let b = rhs.dims[axis]
            if a == b {
                dims[axis] = a
            } else if a == .one {
                dims[axis] = b
            } else if b == .one {
                dims[axis] = a
            } else {
                // axis ≥ 0 by construction; Int → Cardinal is total in this range.
                throw .incompatibleShapes(
                    axis: try! Cardinal(axis),
                    lhs: a,
                    rhs: b
                )
            }
        }
        return Tensor.Shape<Rank>(dims)
    }
}
