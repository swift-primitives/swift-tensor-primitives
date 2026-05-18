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

extension Tensor.View where Element: ~Copyable {
    /// An exclusive-borrowed mutable view into a `Tensor.Value`.
    ///
    /// Per `[API-NAME-001]` and `[API-NAME-008]`, the mutable view is a
    /// variant of `Tensor.View` (multi-form Property.View) — read-only View
    /// and Mutable View are the two forms of viewing a tensor.
    ///
    /// `Tensor.View.Mutable` is `~Copyable, ~Escapable` and lifetime-bound
    /// to the owning tensor's `&self` mutable borrow. The compiler enforces
    /// exclusivity: a mutable view cannot coexist with any other view of
    /// the same tensor. Generic parameters `Element`, `Rank`, `Layout`
    /// are inherited from the enclosing `Tensor.View`.
    ///
    /// ## Safety Invariant
    ///
    /// Category D (SP-5) — `~Escapable` view; the stored `_start` mutable
    /// pointer cannot outlive its source by construction. The view is
    /// produced via a `@_lifetime(borrow start)` initializer; the type
    /// system enforces the lifetime boundary that `withUnsafeMutablePointer`-
    /// style closures enforce by convention. The exclusivity invariant
    /// (no concurrent reader view) is carried by the `~Copyable` and
    /// `@_lifetime(borrow &self)` annotations at the producing-accessor site.
    /// Per [MEM-SAFE-022] `~Escapable` exception, public pointer exposure
    /// is structurally safe.
    @safe
    public struct Mutable: ~Copyable, ~Escapable {
        /// View shape (may differ from owner's after slicing).
        @usableFromInline
        package var _shape: Tensor.Shape<Rank>

        /// View strides.
        @usableFromInline
        package var _strides: Tensor.Strides<Rank>

        /// Exclusive borrowed access to the owner's element buffer.
        @usableFromInline
        package var _start: UnsafeMutablePointer<Element>

        /// Canonical initializer per `[API-IMPL-008]`.
        @inlinable
        @_lifetime(borrow start)
        public init(
            shape: Tensor.Shape<Rank>,
            strides: Tensor.Strides<Rank>,
            _unsafeStart start: UnsafeMutablePointer<Element>
        ) {
            self._shape = shape
            self._strides = strides
            unsafe (self._start = start)
        }
    }
}
