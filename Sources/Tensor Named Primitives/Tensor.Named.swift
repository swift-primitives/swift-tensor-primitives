public import Memory_Heap_Primitives
public import Storage_Contiguous_Primitives
public import Tensor_Primitives_Core

extension Tensor {

    public struct Named<Element: ~Copyable, each Axis: Tensor.Axis.`Protocol`>: ~Copyable {

        @usableFromInline
        package var _dims: [Cardinal]

        @usableFromInline
        package var _storage:
            Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>
                .Linear

        @inlinable
        public init(
            storage:
                consuming Buffer<
                    Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>
                >.Linear
        ) {
            var dims: [Cardinal] = []
            for axisSize in repeat (each Axis).size {
                dims.append(Cardinal(UInt(bitPattern: axisSize)))
            }
            self._dims = dims
            self._storage = storage
        }
    }
}
