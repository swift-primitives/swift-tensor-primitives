public import Tensor_Primitives_Core

extension Tensor.Dynamic {

    public struct Shape: Copyable, Sendable, Equatable {

        public var dims: [Cardinal]

        @inlinable
        public init(_ dims: [Cardinal]) {
            self.dims = dims
        }
    }
}
