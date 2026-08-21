public import Memory_Heap_Primitives
public import Storage_Contiguous_Primitives
public import Tensor_Primitives_Core

extension Tensor.Dynamic {

    public struct `Value`<Element: ~Copyable>: ~Copyable {

        @usableFromInline
        package var _shape: Tensor.Dynamic.Shape

        @usableFromInline
        package var _storage:
            Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>
                .Linear

        @inlinable
        public init(
            shape: Tensor.Dynamic.Shape,
            storage:
                consuming Buffer<
                    Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
                >.Linear
        ) {
            self._shape = shape
            self._storage = storage
        }
    }
}
