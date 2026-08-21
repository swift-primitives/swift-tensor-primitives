extension Tensor.Slice {

    public struct Specification<let Rank: Int>: Copyable, Sendable {

        public var axes: InlineArray<Rank, Tensor.Slice.Axis>

        @inlinable
        public init(_ axes: InlineArray<Rank, Tensor.Slice.Axis>) {
            self.axes = axes
        }
    }
}
