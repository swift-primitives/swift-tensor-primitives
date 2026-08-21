extension Tensor.Shape {

    @inlinable
    public var count: Cardinal {
        var total: Int = 1

        (0..<Rank).forEach { axis in
            total *= Int(bitPattern: dims[axis])
        }
        return Cardinal(UInt(bitPattern: total))
    }
}
