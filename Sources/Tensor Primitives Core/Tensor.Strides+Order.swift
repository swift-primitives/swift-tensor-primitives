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

extension Tensor.Strides {
    /// Constructs row-major (C-order) strides from a shape.
    ///
    /// For shape `(d₀, d₁, …, dₙ₋₁)` the strides are
    /// `(d₁ · d₂ · ⋯ · dₙ₋₁, …, dₙ₋₂ · dₙ₋₁, dₙ₋₁, 1)` — the last axis varies
    /// fastest, with stride 1.
    ///
    /// The argument label `rowMajor:` names the layout per NumPy / Fortran
    /// convention; the initializer overload form satisfies [API-NAME-002] —
    /// the function name is `init`, not a compound identifier.
    @inlinable
    public init(rowMajor shape: Tensor.Shape<Rank>) {
        var values = InlineArray<Rank, Affine.Discrete.Vector>(repeating: .zero)
        if Rank == 0 {
            self.init(values)
            return
        }
        var running: UInt = 1
        // Walk axes in reverse so the last axis gets stride 1. The product-of-
        // dims arithmetic bottoms out at `UInt` because `Cardinal × Cardinal →
        // Cardinal` is intentionally absent per [INFRA-200] (multiplying same-
        // dimension quantities changes dimension). The body is non-throwing,
        // so stdlib `Sequence.forEach` suffices.
        stride(from: Rank - 1, through: 0, by: -1).forEach { k in
            values[k] = Affine.Discrete.Vector(Int(bitPattern: running))
            // Cardinal × Cardinal → Cardinal is principled-absent per
            // [INFRA-200]; the product bottoms out at `Int` via the
            // typed-boundary overload `Int(bitPattern: Cardinal)` ([INFRA-002]).
            running = running &* UInt(bitPattern: Int(bitPattern: shape.dims[k]))
        }
        self.init(values)
    }

    /// Constructs column-major (F-order) strides from a shape.
    ///
    /// For shape `(d₀, d₁, …, dₙ₋₁)` the strides are
    /// `(1, d₀, d₀ · d₁, …)` — the first axis varies fastest, with stride 1.
    @inlinable
    public init(columnMajor shape: Tensor.Shape<Rank>) {
        var values = InlineArray<Rank, Affine.Discrete.Vector>(repeating: .zero)
        if Rank == 0 {
            self.init(values)
            return
        }
        var running: UInt = 1
        (0..<Rank).forEach { k in
            values[k] = Affine.Discrete.Vector(Int(bitPattern: running))
            // Cardinal × Cardinal → Cardinal is principled-absent per
            // [INFRA-200]; the product bottoms out at `Int` via the
            // typed-boundary overload `Int(bitPattern: Cardinal)` ([INFRA-002]).
            running = running &* UInt(bitPattern: Int(bitPattern: shape.dims[k]))
        }
        self.init(values)
    }
}
