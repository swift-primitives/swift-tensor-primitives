extension Tensor.Broadcast {

    @inlinable
    public static func position<let Rank: Int>(
        ofLinearIndex linearIndex: Int,
        in shape: Tensor.Shape<Rank>
    ) -> Tensor.Index.Position<Rank> {
        var positions = InlineArray<Rank, Ordinal>(repeating: .zero)
        var remaining = linearIndex

        stride(from: Rank - 1, through: 0, by: -1).forEach { axis in
            let dim = Int(bitPattern: shape.dims[axis])
            positions[axis] = Ordinal(UInt(bitPattern: remaining % dim))
            remaining /= dim
        }
        return Tensor.Index.Position<Rank>(positions)
    }
}
