extension Tensor.Value where Element: Copyable {

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
