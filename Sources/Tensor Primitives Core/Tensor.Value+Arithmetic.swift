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
        var newStorage = Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        // Stride-aware broadcast traversal. Each operand reads through its
        // own stride vector against the aligned output shape — zero stride
        // on any axis it stretches (`Tensor.Broadcast.strides(of:aligned:)`)
        // — so a length-1 axis repeats its single element for every output
        // position along that axis instead of walking off the end of the
        // smaller operand's buffer at the shared linear offset.
        let lhsStrides = Tensor.Broadcast.strides(of: self._shape, aligned: aligned)
        let rhsStrides = Tensor.Broadcast.strides(of: other._shape, aligned: aligned)
        let n = Int(bitPattern: count)
        (0..<n).forEach { i in
            let position = Tensor.Broadcast.position(ofLinearIndex: i, in: aligned)
            let lhsOffset = position.linearize(strides: lhsStrides)
            let rhsOffset = position.linearize(strides: rhsStrides)
            let lhsIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: lhsOffset))))
            let rhsIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: rhsOffset))))
            newStorage.append(self._storage[lhsIdx] + other._storage[rhsIdx])
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
        var newStorage = Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        // Stride-aware broadcast traversal — see `adding(_:)` above.
        let lhsStrides = Tensor.Broadcast.strides(of: self._shape, aligned: aligned)
        let rhsStrides = Tensor.Broadcast.strides(of: other._shape, aligned: aligned)
        let n = Int(bitPattern: count)
        (0..<n).forEach { i in
            let position = Tensor.Broadcast.position(ofLinearIndex: i, in: aligned)
            let lhsOffset = position.linearize(strides: lhsStrides)
            let rhsOffset = position.linearize(strides: rhsStrides)
            let lhsIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: lhsOffset))))
            let rhsIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: rhsOffset))))
            newStorage.append(self._storage[lhsIdx] - other._storage[rhsIdx])
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
        var newStorage = Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )
        // Stride-aware broadcast traversal — see `Tensor.Value.adding(_:)`.
        let lhsStrides = Tensor.Broadcast.strides(of: self._shape, aligned: aligned)
        let rhsStrides = Tensor.Broadcast.strides(of: other._shape, aligned: aligned)
        let n = Int(bitPattern: count)
        (0..<n).forEach { i in
            let position = Tensor.Broadcast.position(ofLinearIndex: i, in: aligned)
            let lhsOffset = position.linearize(strides: lhsStrides)
            let rhsOffset = position.linearize(strides: rhsStrides)
            let lhsIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: lhsOffset))))
            let rhsIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: rhsOffset))))
            newStorage.append(self._storage[lhsIdx] * other._storage[rhsIdx])
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
        var newStorage = Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear(
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
