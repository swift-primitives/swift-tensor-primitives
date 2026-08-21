extension Tensor {

    public struct Strides<let Rank: Int>: Copyable, Sendable {

        public var values: InlineArray<Rank, Affine.Discrete.Vector>

        @inlinable
        public init(_ values: InlineArray<Rank, Affine.Discrete.Vector>) {
            self.values = values
        }
    }
}
