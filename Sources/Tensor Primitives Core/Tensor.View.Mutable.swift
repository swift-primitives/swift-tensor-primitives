extension Tensor.View where Element: ~Copyable {

    @safe
    public struct Mutable: ~Copyable, ~Escapable {

        @usableFromInline
        package var _shape: Tensor.Shape<Rank>

        @usableFromInline
        package var _strides: Tensor.Strides<Rank>

        @usableFromInline
        package var _start: UnsafeMutablePointer<Element>

        @inlinable
        @_lifetime(borrow start)
        public init(
            shape: Tensor.Shape<Rank>,
            strides: Tensor.Strides<Rank>,
            _unsafeStart start: UnsafeMutablePointer<Element>
        ) {
            self._shape = shape
            self._strides = strides
            unsafe (self._start = start)
        }
    }
}
