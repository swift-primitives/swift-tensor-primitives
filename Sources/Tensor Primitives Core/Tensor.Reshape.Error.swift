extension Tensor.Reshape {

    public enum Error: Swift.Error, Sendable, Equatable {

        case productNotPreserved(from: Cardinal, to: Cardinal)

        case notContiguous
    }
}
