extension Tensor {

    public struct Shape<let Rank: Int>: Copyable, Sendable {

        public var dims: InlineArray<Rank, Cardinal>

        @inlinable
        public init(_ dims: InlineArray<Rank, Cardinal>) {
            self.dims = dims
        }
    }
}
