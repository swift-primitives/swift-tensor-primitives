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

// MARK: - Umbrella per [MOD-005]
//
// The umbrella target's sole role is to re-export Core + variants so consumers
// can write a single `import Tensor_Primitives` and reach the complete L1
// surface.

@_exported public import Tensor_Dynamic_Primitives
@_exported public import Tensor_Named_Primitives
@_exported public import Tensor_Primitives_Core
