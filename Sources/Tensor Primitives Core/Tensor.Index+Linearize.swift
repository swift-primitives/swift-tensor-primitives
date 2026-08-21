extension Tensor.Index.Position {

    @inlinable
    public func linearize(strides: Tensor.Strides<Rank>) -> Affine.Discrete.Vector {
        var total: Int = 0
        (0..<Rank).forEach { k in

            let position = Int(bitPattern: positions[k])
            let stride = Int(bitPattern: strides.values[k])
            total += position * stride
        }
        return Affine.Discrete.Vector(total)
    }

    @inlinable
    public func validate(against shape: Tensor.Shape<Rank>) throws(Tensor.Index.Error) {

        try (0..<Rank).forEach { (k: Int) throws(Tensor.Index.Error) in
            let position = positions[k]
            let bound = shape.dims[k]
            if position >= bound {

                let axisCardinal: Cardinal
                do throws(Cardinal.Error) {
                    axisCardinal = try Cardinal(k)
                } catch {
                    preconditionFailure("k ranges over 0..<Rank, always non-negative: \(error)")
                }
                throw .outOfBounds(
                    axis: axisCardinal,
                    position: position,
                    bound: bound
                )
            }
        }
    }
}
