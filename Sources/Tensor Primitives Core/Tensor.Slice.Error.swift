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

extension Tensor.Slice {
    /// Errors describing a slice-related failure condition.
    public enum Error: Swift.Error, Sendable, Equatable {
        /// The slice range is invalid — start >= end, or out of bounds.
        case invalidRange(axis: Cardinal, start: Ordinal, end: Ordinal, bound: Cardinal)

        /// The slice axis index is out of the tensor's rank.
        case axisOutOfRange(axis: Cardinal, rank: Cardinal)
    }
}
