extension Tensor.Layout.Order {

    public struct Row: _TensorLayoutProtocol {

        @inlinable
        public init() {}
    }
}

extension Tensor.Layout.Order.Row {

    @inlinable
    public static var tag: String { "Row" }

    @inlinable
    public static var isContiguous: Bool { true }
}
