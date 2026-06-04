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
    /// Reshapes this tensor to a new compile-time rank `NewRank`.
    ///
    /// The new shape's element count must equal the original's. The result
    /// is row-major-contiguous regardless of source layout — this is the
    /// "view-if-possible-else-copy" reshape; in this L1 implementation it is
    /// always a copy. A view-only counterpart `reshaping(_:)` returning
    /// `Tensor.View` lives on the view side and throws on non-contiguous
    /// source.
    ///
    /// - Throws: `Tensor.Reshape.Error.productNotPreserved` if element counts
    ///   differ.
    @inlinable
    public func reshape<let NewRank: Int>(
        to newShape: Tensor.Shape<NewRank>
    ) throws(Tensor.Reshape.Error) -> Tensor.Value<Element, NewRank, Tensor.Layout.Order.Row> {
        let fromCount = self._shape.count
        let toCount = newShape.count
        if fromCount != toCount {
            throw .productNotPreserved(from: fromCount, to: toCount)
        }
        var storage = Buffer<Storage<Element>.Heap>.Linear(
            minimumCapacity: Index<Element>.Count(toCount)
        )
        // Sequential copy via Buffer.Linear's Swift.Sequence iteration.
        // For row-major → row-major, flat-iteration preserves layout.
        self._storage.forEach { element in
            storage.append(element)
        }
        return Tensor.Value<Element, NewRank, Tensor.Layout.Order.Row>(
            shape: newShape,
            strides: Tensor.Strides<NewRank>(rowMajor: newShape),
            storage: storage
        )
    }
}
