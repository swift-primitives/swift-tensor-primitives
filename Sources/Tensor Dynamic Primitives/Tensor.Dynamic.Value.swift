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

public import Memory_Heap_Primitives
public import Storage_Contiguous_Primitives
public import Tensor_Primitives_Core

extension Tensor.Dynamic {
    /// A rank-erased tensor whose dimensions are data-dependent.
    ///
    /// `Tensor.Dynamic.Value<Element>` is the rank-erased counterpart to the
    /// statically-ranked `Tensor.Value<Element, Rank, Layout>`. Operations
    /// whose output rank depends on runtime data — `filter`, `where`,
    /// `unique`, `nonzero` — return this type. The carried `Tensor.Dynamic.Shape`
    /// names per-axis cardinalities at runtime; the runtime rank is
    /// `shape.dims.count`.
    public struct `Value`<Element: ~Copyable>: ~Copyable {
        /// Runtime-discoverable per-axis cardinalities.
        @usableFromInline
        package var _shape: Tensor.Dynamic.Shape

        /// Heap-backed element storage.
        @usableFromInline
        package var _storage: Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear

        /// Canonical initializer per `[API-IMPL-008]`.
        @inlinable
        public init(
            shape: Tensor.Dynamic.Shape,
            storage: consuming Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
        ) {
            self._shape = shape
            self._storage = storage
        }
    }
}
