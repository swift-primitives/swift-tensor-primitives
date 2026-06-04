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

extension Tensor.Value
where
    Element: Copyable & AdditiveArithmetic,
    Layout == Tensor.Layout.Order.Row
{
    /// Element-wise addition with broadcast.
    ///
    /// Shapes are aligned via `Tensor.Broadcast.align(_:_:)`. Mismatched
    /// non-unit lengths produce `Tensor.Broadcast.Error.incompatibleShapes`.
    ///
    /// - Throws: `Tensor.Broadcast.Error` on shape mismatch.
    @inlinable
    public func adding(
        _ other: borrowing Tensor.Value<Element, Rank, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let aligned = try Tensor.Broadcast.align(self._shape, other._shape)
        let count = aligned.count
        var newStorage = Buffer<Storage<Element>.Heap>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        // Naive row-major parallel iteration via Swift.Sequence zip.
        // `Buffer.Linear: Swift.Sequence where Element: Copyable` enables this
        // without escaping to flat-index arithmetic per [IMPL-033].
        for (a, b) in zip(self._storage, other._storage) {
            newStorage.append(a + b)
        }
        return Tensor.Value<Element, Rank, Tensor.Layout.Order.Row>(
            shape: aligned,
            strides: Tensor.Strides<Rank>(rowMajor: aligned),
            storage: newStorage
        )
    }

    /// Element-wise subtraction.
    @inlinable
    public func subtracting(
        _ other: borrowing Tensor.Value<Element, Rank, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let aligned = try Tensor.Broadcast.align(self._shape, other._shape)
        let count = aligned.count
        var newStorage = Buffer<Storage<Element>.Heap>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        for (a, b) in zip(self._storage, other._storage) {
            newStorage.append(a - b)
        }
        return Tensor.Value<Element, Rank, Tensor.Layout.Order.Row>(
            shape: aligned,
            strides: Tensor.Strides<Rank>(rowMajor: aligned),
            storage: newStorage
        )
    }
}

extension Tensor.Value
where
    Element: Copyable & Swift.Numeric,
    Layout == Tensor.Layout.Order.Row
{
    /// Element-wise multiplication with broadcast.
    @inlinable
    public func multiplying(
        elementWise other: borrowing Tensor.Value<Element, Rank, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let aligned = try Tensor.Broadcast.align(self._shape, other._shape)
        let count = aligned.count
        var newStorage = Buffer<Storage<Element>.Heap>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        for (a, b) in zip(self._storage, other._storage) {
            newStorage.append(a * b)
        }
        return Tensor.Value<Element, Rank, Tensor.Layout.Order.Row>(
            shape: aligned,
            strides: Tensor.Strides<Rank>(rowMajor: aligned),
            storage: newStorage
        )
    }

    /// Scalar multiplication.
    @inlinable
    public func scaled(by scalar: Element) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let count = self._shape.count
        var newStorage = Buffer<Storage<Element>.Heap>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        // Single-buffer scaling via Swift.Sequence iteration on Buffer.Linear.
        self._storage.forEach { element in
            newStorage.append(element * scalar)
        }
        return Tensor.Value<Element, Rank, Tensor.Layout.Order.Row>(
            shape: self._shape,
            strides: self._strides,
            storage: newStorage
        )
    }
}
