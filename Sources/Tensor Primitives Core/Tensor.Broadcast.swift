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

extension Tensor {
    /// Namespace for tensor broadcast operations.
    ///
    /// Broadcasting aligns two shapes by trailing-dim alignment per the NumPy
    /// rule: axes are matched right-to-left; a length-1 axis on one operand
    /// is "stretched" by zero-stride read repetition; mismatched non-unit
    /// lengths produce `Tensor.Broadcast.Error.incompatibleShapes`.
    public enum Broadcast {}
}
