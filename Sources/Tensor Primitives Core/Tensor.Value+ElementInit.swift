extension Tensor.Value where Element: Copyable, Layout == Tensor.Layout.Order.Row {

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
        var storage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(expected)
        )
        for element in elements {
            storage.append(element)
        }
        let strides = Tensor.Strides<Rank>(rowMajor: shape)
        self.init(shape: shape, strides: strides, storage: storage)
    }
}
