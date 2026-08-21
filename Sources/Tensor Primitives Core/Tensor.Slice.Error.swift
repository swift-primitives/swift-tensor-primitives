extension Tensor.Slice {

    public enum Error: Swift.Error, Sendable, Equatable {

        case invalidRange(axis: Cardinal, start: Ordinal, end: Ordinal, bound: Cardinal)

        case axisOutOfRange(axis: Cardinal, rank: Cardinal)
    }
}
