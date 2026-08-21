extension Tensor.Broadcast {

    @inlinable
    public static func align<let Rank: Int>(
        _ lhs: Tensor.Shape<Rank>,
        _ rhs: Tensor.Shape<Rank>
    ) throws(Error) -> Tensor.Shape<Rank> {
        var dims = InlineArray<Rank, Cardinal>(repeating: .zero)

        try (0..<Rank).forEach { (axis: Int) throws(Error) in
            let a = lhs.dims[axis]
            let b = rhs.dims[axis]
            if a == b {
                dims[axis] = a
            } else if a == .one {
                dims[axis] = b
            } else if b == .one {
                dims[axis] = a
            } else {

                let axisCardinal: Cardinal
                do throws(Cardinal.Error) {
                    axisCardinal = try Cardinal(axis)
                } catch {
                    preconditionFailure("axis ≥ 0 by construction: \(error)")
                }
                throw .incompatibleShapes(
                    axis: axisCardinal,
                    lhs: a,
                    rhs: b
                )
            }
        }
        return Tensor.Shape<Rank>(dims)
    }
}
