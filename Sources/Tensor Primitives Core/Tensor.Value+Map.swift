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
    /// Maps each element through `transform`, producing a new tensor with the
    /// same shape and row-major layout.
    ///
    /// - Parameter transform: A per-element function.
    /// - Returns: A new tensor with `transform` applied to every element.
    /// - Throws: Whatever `transform` throws, propagated from the first failing element.
    @inlinable
    public func map<NewElement: Copyable, E: Swift.Error>(
        _ transform: (Element) throws(E) -> NewElement
    ) throws(E) -> Tensor.Value<NewElement, Rank, Tensor.Layout.Order.Row> {
        let count = self._shape.count
        var storage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<NewElement>
        >.Linear(
            minimumCapacity: Index<NewElement>.Count(count)
        )
        // Iterate elements by linear index. The W3 substrate
        // `Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear` vends index-subscript + `count`
        // (the institute `Sequenceable`/`Iterable` surface, not `Swift.Sequence`).
        // The index-driven `for-in` over `0..<n` preserves the typed throw shape
        // because the body propagates `throws(E)` natively.
        let n = Int(bitPattern: count)
        for i in 0..<n {
            let idx = Index<Element>(_unchecked: Ordinal(UInt(i)))
            storage.append(try transform(self._storage[idx]))
        }
        return Tensor.Value<NewElement, Rank, Tensor.Layout.Order.Row>(
            shape: self._shape,
            strides: Tensor.Strides<Rank>(rowMajor: self._shape),
            storage: storage
        )
    }
}
