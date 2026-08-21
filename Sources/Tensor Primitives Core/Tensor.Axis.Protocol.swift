public protocol _TensorAxisProtocol {

    static var size: Int { get }
}

extension Tensor.Axis {

    public typealias `Protocol` = _TensorAxisProtocol
}
