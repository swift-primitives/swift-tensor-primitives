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

extension Tensor.Shape {
    /// The total number of elements named by this shape: `Π dims`.
    ///
    /// A rank-zero (scalar) shape has count 1.
    @inlinable
    public var count: Cardinal {
        var total: Int = 1
        // Cardinal × Cardinal → Cardinal is principled-absent per [INFRA-200];
        // the product bottoms out at `Int` via the typed-boundary overload
        // `Int(bitPattern: Cardinal)` ([INFRA-002]).
        (0..<Rank).forEach { axis in
            total = total * Int(bitPattern: dims[axis])
        }
        return Cardinal(UInt(bitPattern: total))
    }
}
