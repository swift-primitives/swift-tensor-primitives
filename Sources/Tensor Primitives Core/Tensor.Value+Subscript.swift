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
    /// Reads the element at the given multi-axis position.
    ///
    /// The position is bounds-checked against the tensor's shape via
    /// `Tensor.Index.Position.validate(against:)` and linearized against the
    /// tensor's strides via `Tensor.Index.Position.linearize(strides:)`.
    ///
    /// - Parameter position: Multi-axis index.
    /// - Returns: The element at that position.
    /// - Throws: `Tensor.Index.Error.outOfBounds` on bounds violation.
    @inlinable
    public func element(
        at position: Tensor.Index.Position<Rank>
    ) throws(Tensor.Index.Error) -> Element {
        try position.validate(against: _shape)
        let offset = position.linearize(strides: _strides)
        // Offset is signed Vector; the bounds-check above guarantees offset ≥ 0
        // for a base tensor, so the `Vector → Int → UInt → Ordinal → Index`
        // chain is total. `_unchecked` expresses the static-guarantee directly
        // without a `try!`-on-throwing-arithmetic ceremony.
        let flatIndex = Index<Element>(
            _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: offset)))
        )
        return _storage[flatIndex]
    }
}
