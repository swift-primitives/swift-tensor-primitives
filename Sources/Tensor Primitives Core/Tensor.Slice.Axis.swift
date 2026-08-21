extension Tensor.Slice {

    public enum Axis: Copyable, Sendable, Equatable {

        case full

        case range(start: Ordinal, end: Ordinal)

        case single(Ordinal)

        case newAxis
    }
}
