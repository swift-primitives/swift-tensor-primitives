extension Tensor.Broadcast {

    @inlinable
    public static func strides<let Rank: Int>(
        of shape: Tensor.Shape<Rank>,
        aligned: Tensor.Shape<Rank>
    ) -> Tensor.Strides<Rank> {
        var strides = Tensor.Strides<Rank>(rowMajor: shape)

        (0..<Rank).forEach { axis in
            if shape.dims[axis] == .one && aligned.dims[axis] != .one {
                strides.values[axis] = .zero
            }
        }
        return strides
    }
}
