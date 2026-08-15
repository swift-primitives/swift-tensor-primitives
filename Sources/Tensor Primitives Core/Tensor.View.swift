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
    /// A read-only borrowed view into a `Tensor.Value`.
    ///
    /// `Tensor.View` is the read-only borrow of an owning tensor. It is
    /// `~Copyable, ~Escapable` and lifetime-bound to the owner: the compiler
    /// rejects any use-after-free by reasoning about the borrow at the type
    /// level.
    ///
    /// Views are produced by metadata operations — slice, transpose, broadcast
    /// — that do not copy element storage. The view's shape and strides may
    /// differ from the owner's; the underlying buffer is shared.
    ///
    /// To produce a mutable view, see `Tensor.View.Mutable`.
    ///
    /// ## Safety Invariant
    ///
    /// Category D (SP-5) — `~Escapable` view; the stored `_start` pointer
    /// cannot outlive its source by construction. The view is produced via
    /// a `@_lifetime(borrow start)` initializer; the type system enforces
    /// the lifetime boundary that `withUnsafePointer`-style closures enforce
    /// by convention. Bounds are validated at the operation site via
    /// `Tensor.Index.Position.validate(against:)` and the shape carries the
    /// per-axis cardinalities. Per [MEM-SAFE-022] `~Escapable` exception,
    /// public pointer exposure is structurally safe.
    @safe
    public struct View<Element: ~Copyable, let Rank: Int, Layout: Tensor.Layout.`Protocol`>:
        ~Copyable, ~Escapable
    {
        /// View shape (may differ from owner's after slicing / broadcast).
        @usableFromInline
        package var _shape: Tensor.Shape<Rank>

        /// View strides (zero on broadcast axes; negative on reversed iteration).
        @usableFromInline
        package var _strides: Tensor.Strides<Rank>

        /// Borrowed access to the owner's element buffer.
        ///
        /// Stored as an unsafe pointer is the standard institute pattern for
        /// `~Escapable` views per [MEM-SPAN-001].
        @usableFromInline
        package var _start: UnsafePointer<Element>

        /// Canonical initializer per `[API-IMPL-008]`.
        ///
        /// - Parameters:
        ///   - shape: View shape.
        ///   - strides: Per-axis strides.
        ///   - start: Read-only base pointer into the owner's storage. The
        ///     compiler enforces lifetime via the `@_lifetime` attribute on
        ///     the producing accessor; the view is `~Escapable` so cannot
        ///     outlive the borrow.
        @inlinable
        @_lifetime(borrow start)
        public init(
            shape: Tensor.Shape<Rank>,
            strides: Tensor.Strides<Rank>,
            _unsafeStart start: UnsafePointer<Element>
        ) {
            self._shape = shape
            self._strides = strides
            unsafe (self._start = start)
        }
    }
}
