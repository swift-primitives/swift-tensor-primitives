extension Tensor.Index {

    public struct Position<let Rank: Int>: Copyable, Sendable {

        public var positions: InlineArray<Rank, Ordinal>

        @inlinable
        public init(_ positions: InlineArray<Rank, Ordinal>) {
            self.positions = positions
        }
    }
}
