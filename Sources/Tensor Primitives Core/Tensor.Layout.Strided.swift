extension Tensor.Layout {

    public struct Strided: _TensorLayoutProtocol {

        @inlinable
        public init() {}
    }
}

extension Tensor.Layout.Strided {

    @inlinable
    public static var tag: String { "Strided" }

    @inlinable
    public static var isContiguous: Bool { false }
}
