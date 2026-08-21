extension Tensor.Index {

    public enum Error: Swift.Error, Sendable, Equatable {

        case outOfBounds(axis: Cardinal, position: Ordinal, bound: Cardinal)

        case rankMismatch(expected: Cardinal, actual: Cardinal)
    }
}
