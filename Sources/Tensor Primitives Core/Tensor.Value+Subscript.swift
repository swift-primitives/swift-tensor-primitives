extension Tensor.Value where Element: Copyable {

    @inlinable
    public func element(
        at position: Tensor.Index.Position<Rank>
    ) throws(Tensor.Index.Error) -> Element {
        try position.validate(against: _shape)
        let offset = position.linearize(strides: _strides)

        let flatIndex = Index<Element>(
            _unchecked: Ordinal(UInt(bitPattern: Int(bitPattern: offset)))
        )
        return _storage[flatIndex]
    }
}
