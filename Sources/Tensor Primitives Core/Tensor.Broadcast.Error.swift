// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Tensor.Broadcast {
    /// Errors describing a broadcast-alignment failure.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// Two shapes cannot be aligned: at some axis both lengths exceed 1
        /// and differ.
        ///
        /// - Parameters:
        ///   - axis: The axis at which alignment fails.
        ///   - lhs: Length on the left operand.
        ///   - rhs: Length on the right operand.
        case incompatibleShapes(axis: Cardinal, lhs: Cardinal, rhs: Cardinal)

        /// The operand ranks differ in a way the operation does not permit.
        case rankMismatch(lhs: Cardinal, rhs: Cardinal)
    }
}
