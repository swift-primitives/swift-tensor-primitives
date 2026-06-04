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

// MARK: - External dependency re-exports per [MOD-001] / [MOD-002]
//
// Core is the dependency funnel for the package. Variant targets depend only
// on Core; consumer-facing types from external packages reach them via these
// re-exports.

@_exported public import Tagged_Primitives
@_exported public import Index_Primitives
@_exported public import Cardinal_Primitives
@_exported public import Ordinal_Primitives
@_exported public import Finite_Primitives
@_exported public import Affine_Primitives
@_exported public import Dimension_Primitives
@_exported public import Buffer_Primitives
@_exported public import Buffer_Linear_Primitives
@_exported public import Storage_Primitives
@_exported public import Storage_Primitive
@_exported public import Range_Primitives
@_exported public import Memory_Primitives
@_exported public import Numeric_Primitives
@_exported public import Algebra_Ring_Primitives
@_exported public import Error_Primitives
@_exported public import Format_Primitives
@_exported public import Sequence_Primitives
@_exported public import Vector_Primitives
