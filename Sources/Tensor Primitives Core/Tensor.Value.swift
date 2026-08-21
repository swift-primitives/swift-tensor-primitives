extension Tensor {

    public struct `Value`<Element: ~Copyable, let Rank: Int, Layout: Tensor.Layout.`Protocol`>:
        ~Copyable
    {

        @usableFromInline
        package var _shape: Tensor.Shape<Rank>

        @usableFromInline
        package var _strides: Tensor.Strides<Rank>

        @usableFromInline
        package var _storage:
            Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>
                .Linear

        @inlinable
        public init(
            shape: Tensor.Shape<Rank>,
            strides: Tensor.Strides<Rank>,
            storage:
                consuming Buffer<
                    Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
                >.Linear
        ) {
            self._shape = shape
            self._strides = strides
            self._storage = storage
        }
    }
}
