extension Tensor.Value
where
    Element: Copyable & AdditiveArithmetic,
    Layout == Tensor.Layout.Order.Row
{

    @inlinable
    public func sum() -> Element {
        var total = Element.zero

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
