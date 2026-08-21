extension Tensor {

    @safe
    public struct View<Element: ~Copyable, let Rank: Int, Layout: Tensor.Layout.`Protocol`>:
        ~Copyable, ~Escapable
    {

        @usableFromInline
        package var _shape: Tensor.Shape<Rank>

        @usableFromInline
        package var _strides: Tensor.Strides<Rank>

        @usableFromInline
        package var _start: UnsafePointer<Element>

        @inlinable
        @_lifetime(borrow start)
        public init(
            shape: Tensor.Shape<Rank>,
            strides: Tensor.Strides<Rank>,
            _unsafeStart start: UnsafePointer<Element>
        ) {
            self._shape = shape
            self._strides = strides
            unsafe (self._start = start)
        }
    }
}
