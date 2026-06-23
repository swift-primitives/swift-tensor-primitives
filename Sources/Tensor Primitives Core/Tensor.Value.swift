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
    /// A runtime-shape n-dimensional tensor.
    ///
    /// `Tensor<Element, Rank, Layout>` is the L1 owned value type. Rank is a
    /// compile-time `Int` value generic (SE-0452); per-axis sizes live at
    /// runtime in the accompanying `Shape<Rank>`; the `Layout` witness
    /// drives per-layout dispatch at zero runtime cost.
    ///
    /// Storage is exclusively owned via `Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear`. The tensor
    /// is `~Copyable` to express that ownership; the only way to share data
    /// across uses is via `Tensor.View` (borrowed) and
    /// `Tensor.View.Mutable` (exclusive-borrowed) which are themselves
    /// `~Copyable, ~Escapable` lifetime-bound to the owning tensor.
    ///
    /// Per `[API-IMPL-008]`, the type body holds only stored properties and
    /// the canonical initializer; all methods live in `+`-suffixed extension
    /// files.
    public struct `Value`<Element: ~Copyable, let Rank: Int, Layout: Tensor.Layout.`Protocol`>: ~Copyable {
        /// Runtime per-axis cardinalities.
        @usableFromInline
        package var _shape: Tensor.Shape<Rank>

        /// Runtime per-axis strides (element-counts, signed).
        @usableFromInline
        package var _strides: Tensor.Strides<Rank>

        /// Heap-backed element storage.
        @usableFromInline
        package var _storage: Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear

        /// Canonical initializer per `[API-IMPL-008]`.
        ///
        /// - Parameters:
        ///   - shape: Per-axis cardinalities.
        ///   - strides: Per-axis signed strides (element counts).
        ///   - storage: Element storage. Caller transfers ownership.
        @inlinable
        public init(
            shape: Tensor.Shape<Rank>,
            strides: Tensor.Strides<Rank>,
            storage: consuming Buffer<Storage_Primitive.Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear
        ) {
            self._shape = shape
            self._strides = strides
            self._storage = storage
        }
    }
}
