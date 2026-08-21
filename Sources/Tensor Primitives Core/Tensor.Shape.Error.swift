extension Tensor.Shape {

    public enum Error: Swift.Error, Sendable, Equatable {

        case elementCountMismatch(expected: Cardinal, actual: Cardinal)

        case unexpectedScalarShape

        case zeroDimensionForbidden(axis: Cardinal)
    }
}
