extension Tensor.Layout.Order {

    public struct Column: _TensorLayoutProtocol {

        @inlinable
        public init() {}
    }
}

extension Tensor.Layout.Order.Column {

    @inlinable
    public static var tag: String { "Column" }

    @inlinable
    public static var isContiguous: Bool { true }
}
