extension Tensor.Value {

    @inlinable
    public var shape: Tensor.Shape<Rank> {
        _shape
    }

    @inlinable
    public var strides: Tensor.Strides<Rank> {
        _strides
    }
}
