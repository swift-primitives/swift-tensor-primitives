extension Tensor.Value where Element: Copyable {

    @inlinable
    public func reshape<let NewRank: Int>(
        to newShape: Tensor.Shape<NewRank>
    ) throws(Tensor.Reshape.Error) -> Tensor.Value<Element, NewRank, Tensor.Layout.Order.Row> {
        let fromCount = self._shape.count
        let toCount = newShape.count
        if fromCount != toCount {
            throw .productNotPreserved(from: fromCount, to: toCount)
        }
        var storage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(toCount)
        )

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
