extension Tensor.Value
where
    Element: Copyable & Swift.Numeric,
    Layout == Tensor.Layout.Order.Row,
    Rank == 2
{

    @inlinable
    public func multiplied(
        by other: borrowing Tensor.Value<Element, 2, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, 2, Tensor.Layout.Order.Row> {
        let m = self._shape.dims[0]
        let p = self._shape.dims[1]
        let pOther = other._shape.dims[0]
        let n = other._shape.dims[1]
        if p != pOther {
            throw .incompatibleShapes(axis: .one, lhs: p, rhs: pOther)
        }

        var resultDims = InlineArray<2, Cardinal>(repeating: .zero)
        resultDims[0] = m
        resultDims[1] = n
        let resultShape = Tensor.Shape<2>(resultDims)
        let total = resultShape.count

        var storage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(total)
        )

        let mInt = Int(bitPattern: m)
        let pInt = Int(bitPattern: p)
        let nInt = Int(bitPattern: n)
        let aRowStride = Int(bitPattern: self._strides.values[0])
        let aColStride = Int(bitPattern: self._strides.values[1])
        let bRowStride = Int(bitPattern: other._strides.values[0])
        let bColStride = Int(bitPattern: other._strides.values[1])

        (0..<mInt).forEach { i in
            (0..<nInt).forEach { k in
                var accumulator = Element.zero
                (0..<pInt).forEach { j in

                    let aOffset = i * aRowStride + j * aColStride
                    let bOffset = j * bRowStride + k * bColStride
                    let aIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: aOffset)))
                    let bIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: bOffset)))
                    accumulator += self._storage[aIdx] * other._storage[bIdx]
                }
                storage.append(accumulator)
            }
        }

        return Tensor.Value<Element, 2, Tensor.Layout.Order.Row>(
            shape: resultShape,
            strides: Tensor.Strides<2>(rowMajor: resultShape),
            storage: storage
        )
    }
}
