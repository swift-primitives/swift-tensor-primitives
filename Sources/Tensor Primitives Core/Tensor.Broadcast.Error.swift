extension Tensor.Broadcast {

    public enum Error: Swift.Error, Sendable, Equatable {

        case incompatibleShapes(axis: Cardinal, lhs: Cardinal, rhs: Cardinal)

        case rankMismatch(lhs: Cardinal, rhs: Cardinal)
    }
}
