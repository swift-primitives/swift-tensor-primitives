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

extension Tensor.Index.Position {
    /// Compute the linear element offset from this multi-axis position and
    /// a given stride vector.
    ///
    /// The linear-index formula is `offset = Σ strides[k] · positions[k]`.
    /// The returned value is a signed displacement; negative strides can
    /// produce a negative offset before a base-pointer adjustment.
    ///
    /// The math is fundamentally dimensional-mixing (`Ordinal × Vector → Vector`)
    /// at the bottom-out boundary of the tensor's typed surface. The institute's
    /// affine arithmetic ([INFRA-104]) supports `Tagged<From, Vector> * Ratio<From, To>`
    /// scaling but not `Vector × Ordinal` (per [INFRA-200] principled absence,
    /// dimension-mixing). For tensor row-major / column-major linearization,
    /// `Int`-arithmetic is the boundary. The body is non-throwing, so
    /// stdlib's inherited `Sequence.forEach` resolves at the call site
    /// (see `validate(against:)` for the typed-throws variant, which
    /// selects the institute `Property`-accessor path on the same
    /// `forEach` verb).
    @inlinable
    public func linearize(strides: Tensor.Strides<Rank>) -> Affine.Discrete.Vector {
        var total: Int = 0
        (0..<Rank).forEach { k in
            // Linearize formula bottoms out at `Int` because the typed system
            // intentionally lacks `Vector × Ordinal → Vector` per [INFRA-200].
            let position = Int(bitPattern: positions[k])
            let stride = Int(bitPattern: strides.values[k])
            total = total + position * stride
        }
        return Affine.Discrete.Vector(total)
    }

    /// Bounds-check this position against a shape.
    ///
    /// - Throws: `Tensor.Index.Error.outOfBounds` if any axis position is
    ///   greater than or equal to the corresponding shape dimension.
    @inlinable
    public func validate(against shape: Tensor.Shape<Rank>) throws(Tensor.Index.Error) {
        // `forEach` is routed through the institute's `Property` accessor
        // on `Swift.Range` (see `Swift.Range+ForEach.swift` in
        // `swift-vector-primitives`); typed-throws closures select the
        // Property path while non-throwing call sites continue to use
        // stdlib's inherited `Sequence.forEach`. Preserves `throws(E)` past
        // the closure boundary per `[API-ERR-005]` and climbs the iteration
        // ladder per `[IMPL-033]`.
        try (0..<Rank).forEach { (k: Int) throws(Tensor.Index.Error) in
            let position = positions[k]
            let bound = shape.dims[k]
            if position >= bound {
                throw .outOfBounds(
                    axis: try! Cardinal(k),
                    position: position,
                    bound: bound
                )
            }
        }
    }
}
