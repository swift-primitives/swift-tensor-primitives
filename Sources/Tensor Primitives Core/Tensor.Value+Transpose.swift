extension Tensor.Value where Element: Copyable {

    @inlinable
    public func transposed() -> Tensor.Value<Element, Rank, Tensor.Layout.Strided>
    where Rank == 2 {
        var newDims = InlineArray<2, Cardinal>(repeating: .zero)
        newDims[0] = _shape.dims[1]
        newDims[1] = _shape.dims[0]
        let newShape = Tensor.Shape<2>(newDims)
        let count = newShape.count
        var newStorage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )

        let rows = Int(bitPattern: newDims[0])
        let cols = Int(bitPattern: newDims[1])
        let stride0 = Int(bitPattern: _strides.values[0])
        let stride1 = Int(bitPattern: _strides.values[1])
        (0..<rows).forEach { newI in
            (0..<cols).forEach { newJ in

                let srcOffset = newJ * stride0 + newI * stride1
                let idx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: srcOffset)))
                newStorage.append(_storage[idx])
            }
        }
        let newStrides = Tensor.Strides<2>(rowMajor: newShape)
        return Tensor.Value<Element, 2, Tensor.Layout.Strided>(
            shape: newShape,
            strides: newStrides,
            storage: newStorage
        )
    }
}
