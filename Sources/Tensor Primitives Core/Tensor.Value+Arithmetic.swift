extension Tensor.Value
where
    Element: Copyable & AdditiveArithmetic,
    Layout == Tensor.Layout.Order.Row
{

    @inlinable
    public func adding(
        _ other: borrowing Tensor.Value<Element, Rank, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let aligned = try Tensor.Broadcast.align(self._shape, other._shape)
        let count = aligned.count
        var newStorage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )

        let lhsStrides = Tensor.Broadcast.strides(of: self._shape, aligned: aligned)
        let rhsStrides = Tensor.Broadcast.strides(of: other._shape, aligned: aligned)
        let n = Int(bitPattern: count)
        (0..<n).forEach { i in
            let position = Tensor.Broadcast.position(ofLinearIndex: i, in: aligned)
            let lhsOffset = position.linearize(strides: lhsStrides)
            let rhsOffset = position.linearize(strides: rhsStrides)
            let lhsIdx = Index<Element>(
                _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: lhsOffset)))
            )
            let rhsIdx = Index<Element>(
                _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: rhsOffset)))
            )
            newStorage.append(self._storage[lhsIdx] + other._storage[rhsIdx])
        }
        return Tensor.Value<Element, Rank, Tensor.Layout.Order.Row>(
            shape: aligned,
            strides: Tensor.Strides<Rank>(rowMajor: aligned),
            storage: newStorage
        )
    }

    @inlinable
    public func subtracting(
        _ other: borrowing Tensor.Value<Element, Rank, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let aligned = try Tensor.Broadcast.align(self._shape, other._shape)
        let count = aligned.count
        var newStorage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )

        let lhsStrides = Tensor.Broadcast.strides(of: self._shape, aligned: aligned)
        let rhsStrides = Tensor.Broadcast.strides(of: other._shape, aligned: aligned)
        let n = Int(bitPattern: count)
        (0..<n).forEach { i in
            let position = Tensor.Broadcast.position(ofLinearIndex: i, in: aligned)
            let lhsOffset = position.linearize(strides: lhsStrides)
            let rhsOffset = position.linearize(strides: rhsStrides)
            let lhsIdx = Index<Element>(
                _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: lhsOffset)))
            )
            let rhsIdx = Index<Element>(
                _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: rhsOffset)))
            )
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

    @inlinable
    public func multiplying(
        elementWise other: borrowing Tensor.Value<Element, Rank, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let aligned = try Tensor.Broadcast.align(self._shape, other._shape)
        let count = aligned.count
        var newStorage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )

        let lhsStrides = Tensor.Broadcast.strides(of: self._shape, aligned: aligned)
        let rhsStrides = Tensor.Broadcast.strides(of: other._shape, aligned: aligned)
        let n = Int(bitPattern: count)
        (0..<n).forEach { i in
            let position = Tensor.Broadcast.position(ofLinearIndex: i, in: aligned)
            let lhsOffset = position.linearize(strides: lhsStrides)
            let rhsOffset = position.linearize(strides: rhsStrides)
            let lhsIdx = Index<Element>(
                _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: lhsOffset)))
            )
            let rhsIdx = Index<Element>(
                _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: rhsOffset)))
            )
            newStorage.append(self._storage[lhsIdx] * other._storage[rhsIdx])
        }
        return Tensor.Value<Element, Rank, Tensor.Layout.Order.Row>(
            shape: aligned,
            strides: Tensor.Strides<Rank>(rowMajor: aligned),
            storage: newStorage
        )
    }

    @inlinable
    public func scaled(by scalar: Element) -> Tensor.Value<Element, Rank, Tensor.Layout.Order.Row> {
        let count = self._shape.count
        var newStorage = Buffer<
            Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
        >.Linear(
            minimumCapacity: Index<Element>.Count(count)
        )

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
