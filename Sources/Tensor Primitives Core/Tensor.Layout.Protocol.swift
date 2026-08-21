public protocol _TensorLayoutProtocol: Sendable {

    static var tag: String { get }

    static var isContiguous: Bool { get }
}

extension Tensor.Layout {

    public typealias `Protocol` = _TensorLayoutProtocol
}
