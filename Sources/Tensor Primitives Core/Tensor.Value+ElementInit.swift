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

extension Tensor.Value where Element: Copyable, Layout == Tensor.Layout.Order.Row {
    /// Constructs a row-major tensor from a flat element list.
    ///
    /// - Parameters:
    ///   - shape: Per-axis cardinalities. The shape's `elementCount` MUST equal
    ///     `elements.count`.
    ///   - elements: Flat element list in row-major order.
    /// - Throws: `Tensor.Shape<Rank>.Error.elementCountMismatch` if the
    ///   element count does not match `shape.count`.
    @inlinable
    public init(
        shape: Tensor.Shape<Rank>,
        elements: [Element]
    ) throws(Tensor.Shape<Rank>.Error) {
        let expected = shape.count
        let actual = Cardinal(UInt(bitPattern: elements.count))
        if expected != actual {
            throw .elementCountMismatch(expected: expected, actual: actual)
        }
        var storage = Buffer<Storage_Primitive.Storage<Element>.Contiguous<Memory.Heap<Element>>>.Linear(
            minimumCapacity: Index<Element>.Count(expected)
        )
        for element in elements {
            storage.append(element)
        }
        let strides = Tensor.Strides<Rank>(rowMajor: shape)
        self.init(shape: shape, strides: strides, storage: storage)
    }
}
