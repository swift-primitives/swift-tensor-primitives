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
    Element: Copyable & Swift.Numeric,
    Layout == Tensor.Layout.Order.Row,
    Rank == 2
{
    /// Pure-Swift naive matrix multiplication for rank-2 tensors.
    ///
    /// Computes `C[i,k] = Σⱼ A[i,j] · B[j,k]` for `A: (m, p)` and `B: (p, n)`.
    /// Output shape is `(m, n)`. Algorithm is naive O(n³); BLAS-dispatched
    /// matmul lives at L3 `swift-tensors` per [PLAT-ARCH-008j].
    ///
    /// - Throws: `Tensor.Broadcast.Error.incompatibleShapes` when the inner
    ///   dimensions don't match.
    @inlinable
    public func multiplied(
        by other: borrowing Tensor.Value<Element, 2, Layout>
    ) throws(Tensor.Broadcast.Error) -> Tensor.Value<Element, 2, Tensor.Layout.Order.Row> {
        let m = self._shape.dims[0]
        let p = self._shape.dims[1]
        let pOther = other._shape.dims[0]
        let n = other._shape.dims[1]
        if p != pOther {
            throw .incompatibleShapes(axis: .one, lhs: p, rhs: pOther)
        }

        var resultDims = InlineArray<2, Cardinal>(repeating: .zero)
        resultDims[0] = m
        resultDims[1] = n
        let resultShape = Tensor.Shape<2>(resultDims)
        let total = resultShape.count

        var storage = Buffer<Storage_Primitive.Storage<Element>.Heap>.Linear(
            minimumCapacity: Index<Element>.Count(total)
        )

        // Stride math at the L1 boundary: BLAS-style ijk matmul with explicit
        // stride accumulation. `aRowStride * i + aColStride * j` is the same
        // dimension-mixing `Ordinal × Vector` math as linearize per [INFRA-200].
        // The bodies are non-throwing (the index advance is via `_unchecked`
        // construction), so stdlib `Range.forEach` suffices — no need to climb
        // to the typed-throws `forEach` Property path (which is
        // [IMPL-033]'s remedy for typed-throws contexts, not for
        // non-throwing iteration).
        let mInt = Int(bitPattern: m)
        let pInt = Int(bitPattern: p)
        let nInt = Int(bitPattern: n)
        let aRowStride = Int(bitPattern: self._strides.values[0])
        let aColStride = Int(bitPattern: self._strides.values[1])
        let bRowStride = Int(bitPattern: other._strides.values[0])
        let bColStride = Int(bitPattern: other._strides.values[1])

        (0..<mInt).forEach { i in
            (0..<nInt).forEach { k in
                var accumulator = Element.zero
                (0..<pInt).forEach { j in
                    // aOffset / bOffset are non-negative by construction
                    // (i, j, k ≥ 0 and strides ≥ 0 for a base tensor), so the
                    // `Int → UInt → Ordinal → Index<Element>` chain is total.
                    // `_unchecked` expresses the static-guarantee directly
                    // without a `try!`-on-throwing-arithmetic ceremony.
                    let aOffset = i * aRowStride + j * aColStride
                    let bOffset = j * bRowStride + k * bColStride
                    let aIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: aOffset)))
                    let bIdx = Index<Element>(_unchecked: Ordinal(UInt(bitPattern: bOffset)))
                    accumulator = accumulator + self._storage[aIdx] * other._storage[bIdx]
                }
                storage.append(accumulator)
            }
        }

        return Tensor.Value<Element, 2, Tensor.Layout.Order.Row>(
            shape: resultShape,
            strides: Tensor.Strides<2>(rowMajor: resultShape),
            storage: storage
        )
    }
}
