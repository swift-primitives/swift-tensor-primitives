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

extension Tensor.Value
where
    Element: Copyable & AdditiveArithmetic,
    Layout == Tensor.Layout.Order.Row
{
    /// Sum-reduction over all elements.
    ///
    /// - Returns: The sum of every element in the tensor.
    @inlinable
    public func sum() -> Element {
        var total = Element.zero
        // Single-buffer iteration via Buffer.Linear's Swift.Sequence conformance.
        self._storage.forEach { element in
            total += element
        }
        return total
    }
}

extension Tensor.Value
where
    Element: Copyable & Swift.Numeric,
    Layout == Tensor.Layout.Order.Row
{
    /// Product-reduction over all elements.
    @inlinable
    public func product() -> Element {
        var total = Element(exactly: 1) ?? Element.zero
        self._storage.forEach { element in
            total *= element
        }
        return total
    }
}

extension Tensor.Value
where
    Element: Copyable & Comparable,
    Layout == Tensor.Layout.Order.Row
{
    /// Minimum-reduction over all elements.
    ///
    /// - Returns: The smallest element, or `nil` if the tensor is empty.
    @inlinable
    public func minimum() -> Element? {
        var current: Element? = nil
        self._storage.forEach { element in
            if let c = current {
                if element < c { current = element }
            } else {
                current = element
            }
        }
        return current
    }

    /// Maximum-reduction over all elements.
    @inlinable
    public func maximum() -> Element? {
        var current: Element? = nil
        self._storage.forEach { element in
            if let c = current {
                if element > c { current = element }
            } else {
                current = element
            }
        }
        return current
    }
}
