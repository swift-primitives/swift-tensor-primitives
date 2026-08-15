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

import Tensor_Primitives_Test_Support
import Testing

// `Tensor.Value<Element, Rank, Layout>` is generic, so per [SWIFT-TEST-003] we use
// the parallel-namespace pattern rather than `extension Tensor.Value { @Suite struct Test {} }`.

@Suite
struct `Tensor Value Operations Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

// MARK: - Test Helpers

/// Reads element at coordinates (i, j) from a rank-2 tensor.
///
/// Lifted to file scope so each test extension can call it. The name uses
/// the `read.element(at:_:)` nested-accessor form per [API-NAME-002].
private func readElement<Element: Copyable, Layout: Tensor.Layout.`Protocol`>(
    from tensor: borrowing Tensor.Value<Element, 2, Layout>,
    at i: Int,
    _ j: Int
) throws(Tensor.Index.Error) -> Element where Element: Copyable {
    var positions = InlineArray<2, Ordinal>(repeating: Ordinal(0))
    positions[0] = Ordinal(UInt(i))
    positions[1] = Ordinal(UInt(j))
    let pos = Tensor.Index.Position<2>(positions)
    return try tensor.element(at: pos)
}

/// Constructs a rank-2 shape with given rows and columns.
private func rank2Shape(_ rows: Int, _ cols: Int) -> Tensor.Shape<2> {
    var dims = InlineArray<2, Cardinal>(repeating: .zero)
    dims[0] = Cardinal(UInt(rows))
    dims[1] = Cardinal(UInt(cols))
    return Tensor.Shape<2>(dims)
}

/// Reads element at coordinates (i, j, k) from a rank-3 tensor.
private func readElement3<Element: Copyable, Layout: Tensor.Layout.`Protocol`>(
    from tensor: borrowing Tensor.Value<Element, 3, Layout>,
    at i: Int,
    _ j: Int,
    _ k: Int
) throws(Tensor.Index.Error) -> Element where Element: Copyable {
    var positions = InlineArray<3, Ordinal>(repeating: Ordinal(0))
    positions[0] = Ordinal(UInt(i))
    positions[1] = Ordinal(UInt(j))
    positions[2] = Ordinal(UInt(k))
    let pos = Tensor.Index.Position<3>(positions)
    return try tensor.element(at: pos)
}

/// Constructs a rank-3 shape with the given per-axis cardinalities.
private func rank3Shape(_ d0: Int, _ d1: Int, _ d2: Int) -> Tensor.Shape<3> {
    var dims = InlineArray<3, Cardinal>(repeating: .zero)
    dims[0] = Cardinal(UInt(d0))
    dims[1] = Cardinal(UInt(d1))
    dims[2] = Cardinal(UInt(d2))
    return Tensor.Shape<3>(dims)
}

// MARK: - Unit Tests

extension `Tensor Value Operations Tests`.Unit {
    @Test
    func `element-wise addition produces correct sums`() throws {
        let shape = rank2Shape(2, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4]
        )
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [10, 20, 30, 40]
        )
        let result = try a.adding(b)
        #expect(try readElement(from: result, at: 0, 0) == 11)
        #expect(try readElement(from: result, at: 0, 1) == 22)
        #expect(try readElement(from: result, at: 1, 0) == 33)
        #expect(try readElement(from: result, at: 1, 1) == 44)
    }

    @Test
    func `element-wise subtraction produces correct differences`() throws {
        let shape = rank2Shape(2, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [10, 20, 30, 40]
        )
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4]
        )
        let result = try a.subtracting(b)
        #expect(try readElement(from: result, at: 0, 0) == 9)
        #expect(try readElement(from: result, at: 1, 1) == 36)
    }

    @Test
    func `scalar multiplication scales every element by the scalar`() throws {
        let shape = rank2Shape(2, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4]
        )
        let result = a.scaled(by: 3)
        #expect(try readElement(from: result, at: 0, 0) == 3)
        #expect(try readElement(from: result, at: 1, 1) == 12)
    }

    @Test
    func `sum reduction returns total across all elements`() throws {
        let shape = rank2Shape(2, 3)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4, 5, 6]
        )
        #expect(a.sum() == 21)
    }

    @Test
    func `product reduction returns multiplied total`() throws {
        let shape = rank2Shape(2, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4]
        )
        #expect(a.product() == 24)
    }

    @Test
    func `min and max reductions return extremes`() throws {
        let shape = rank2Shape(2, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [4, 1, 9, 3]
        )
        #expect(a.minimum() == 1)
        #expect(a.maximum() == 9)
    }

    @Test
    func `transpose swaps axes for rank-2 tensor`() throws {
        let shape = rank2Shape(2, 3)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4, 5, 6]
        )
        // Original: [[1,2,3],[4,5,6]]
        // Transposed: [[1,4],[2,5],[3,6]]
        let tA = a.transposed()
        #expect(tA.shape.dims[0] == Cardinal(3))
        #expect(tA.shape.dims[1] == Cardinal(2))
        #expect(try readElement(from: tA, at: 0, 0) == 1)
        #expect(try readElement(from: tA, at: 0, 1) == 4)
        #expect(try readElement(from: tA, at: 2, 1) == 6)
    }

    @Test
    func `matmul of 2x3 by 3x2 produces 2x2 result`() throws {
        let aShape = rank2Shape(2, 3)
        let bShape = rank2Shape(3, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: aShape,
            elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: bShape,
            elements: [7, 8, 9, 10, 11, 12]
        )
        // [[1,2,3],[4,5,6]] · [[7,8],[9,10],[11,12]]
        // = [[1·7+2·9+3·11, 1·8+2·10+3·12],
        //    [4·7+5·9+6·11, 4·8+5·10+6·12]]
        // = [[58, 64], [139, 154]]
        let c = try a.multiplied(by: b)
        #expect(c.shape.dims[0] == Cardinal(2))
        #expect(c.shape.dims[1] == Cardinal(2))
        #expect(try readElement(from: c, at: 0, 0) == 58)
        #expect(try readElement(from: c, at: 0, 1) == 64)
        #expect(try readElement(from: c, at: 1, 0) == 139)
        #expect(try readElement(from: c, at: 1, 1) == 154)
    }

    @Test
    func `reshape from rank-1 to rank-2 preserves elements`() throws {
        // Start with a rank-1 tensor of 6, reshape to (2,3) then (3,2).
        var dims1 = InlineArray<1, Cardinal>(repeating: .zero)
        dims1[0] = Cardinal(6)
        let shape1 = Tensor.Shape<1>(dims1)
        let a = try Tensor.Value<Int, 1, Tensor.Layout.Order.Row>(
            shape: shape1,
            elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try a.reshape(to: rank2Shape(2, 3))
        #expect(b.shape.dims[0] == Cardinal(2))
        #expect(b.shape.dims[1] == Cardinal(3))
        #expect(try readElement(from: b, at: 0, 0) == 1)
        #expect(try readElement(from: b, at: 1, 2) == 6)

        let c = try b.reshape(to: rank2Shape(3, 2))
        #expect(c.shape.dims[0] == Cardinal(3))
        #expect(c.shape.dims[1] == Cardinal(2))
        #expect(try readElement(from: c, at: 0, 0) == 1)
        #expect(try readElement(from: c, at: 2, 1) == 6)
    }

    @Test
    func `map applies transform to every element`() throws {
        let shape = rank2Shape(2, 2)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4]
        )
        let doubled: Tensor.Value<Int, 2, Tensor.Layout.Order.Row> =
            a.map { (x: Int) -> Int in x * 2 }
        #expect(try readElement(from: doubled, at: 0, 0) == 2)
        #expect(try readElement(from: doubled, at: 1, 1) == 8)
    }

    // MARK: - F-001 regression: broadcast arithmetic must not read past the
    // smaller operand's buffer at the shared linear offset. Each case below
    // has an aligned output element count strictly greater than at least one
    // operand's own element count, so a naive shared-linear-offset kernel
    // either indexes out of bounds (traps) or, when it doesn't trap, mixes
    // up the wrong elements — it must instead repeat the stretched axis via
    // zero-stride reads.

    @Test
    func `broadcast addition of (1,3) and (2,3) repeats the length-1 row`() throws {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = .one
        dimsA[1] = Cardinal(3)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsA),
            elements: [1, 2, 3]
        )
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: rank2Shape(2, 3),
            elements: [10, 20, 30, 40, 50, 60]
        )
        let result = try a.adding(b)
        #expect(result.shape.dims[0] == Cardinal(2))
        #expect(result.shape.dims[1] == Cardinal(3))
        #expect(try readElement(from: result, at: 0, 0) == 11)
        #expect(try readElement(from: result, at: 0, 1) == 22)
        #expect(try readElement(from: result, at: 0, 2) == 33)
        #expect(try readElement(from: result, at: 1, 0) == 41)
        #expect(try readElement(from: result, at: 1, 1) == 52)
        #expect(try readElement(from: result, at: 1, 2) == 63)
    }

    @Test
    func `broadcast addition of (2,1) and (1,2) produces the outer sum`() throws {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = Cardinal(2)
        dimsA[1] = .one
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsA),
            elements: [1, 2]
        )
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = .one
        dimsB[1] = Cardinal(2)
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsB),
            elements: [10, 20]
        )
        let result = try a.adding(b)
        #expect(result.shape.dims[0] == Cardinal(2))
        #expect(result.shape.dims[1] == Cardinal(2))
        #expect(try readElement(from: result, at: 0, 0) == 11)
        #expect(try readElement(from: result, at: 0, 1) == 21)
        #expect(try readElement(from: result, at: 1, 0) == 12)
        #expect(try readElement(from: result, at: 1, 1) == 22)
    }

    @Test
    func `broadcast addition of rank-3 (2,1,3) and (1,2,3) broadcasts two distinct axes`() throws {
        let a = try Tensor.Value<Int, 3, Tensor.Layout.Order.Row>(
            shape: rank3Shape(2, 1, 3),
            elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try Tensor.Value<Int, 3, Tensor.Layout.Order.Row>(
            shape: rank3Shape(1, 2, 3),
            elements: [10, 20, 30, 40, 50, 60]
        )
        let result = try a.adding(b)
        #expect(result.shape.dims[0] == Cardinal(2))
        #expect(result.shape.dims[1] == Cardinal(2))
        #expect(result.shape.dims[2] == Cardinal(3))
        #expect(try readElement3(from: result, at: 0, 0, 0) == 11)
        #expect(try readElement3(from: result, at: 0, 0, 2) == 33)
        #expect(try readElement3(from: result, at: 0, 1, 0) == 41)
        #expect(try readElement3(from: result, at: 0, 1, 2) == 63)
        #expect(try readElement3(from: result, at: 1, 0, 0) == 14)
        #expect(try readElement3(from: result, at: 1, 0, 2) == 36)
        #expect(try readElement3(from: result, at: 1, 1, 0) == 44)
        #expect(try readElement3(from: result, at: 1, 1, 2) == 66)
    }

    @Test
    func `broadcast subtraction of (2,1) and (1,2) produces the outer difference`() throws {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = Cardinal(2)
        dimsA[1] = .one
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsA),
            elements: [10, 20]
        )
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = .one
        dimsB[1] = Cardinal(2)
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsB),
            elements: [1, 2]
        )
        let result = try a.subtracting(b)
        #expect(try readElement(from: result, at: 0, 0) == 9)
        #expect(try readElement(from: result, at: 0, 1) == 8)
        #expect(try readElement(from: result, at: 1, 0) == 19)
        #expect(try readElement(from: result, at: 1, 1) == 18)
    }

    @Test
    func `broadcast element-wise multiplication of (2,1) and (1,2) produces the outer product`()
        throws
    {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = Cardinal(2)
        dimsA[1] = .one
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsA),
            elements: [2, 3]
        )
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = .one
        dimsB[1] = Cardinal(2)
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: Tensor.Shape<2>(dimsB),
            elements: [5, 7]
        )
        let result = try a.multiplying(elementWise: b)
        #expect(try readElement(from: result, at: 0, 0) == 10)
        #expect(try readElement(from: result, at: 0, 1) == 14)
        #expect(try readElement(from: result, at: 1, 0) == 15)
        #expect(try readElement(from: result, at: 1, 1) == 21)
    }
}

// MARK: - Integration Tests

extension `Tensor Value Operations Tests`.Integration {
    @Test
    func `broadcast align on same shape returns same shape`() throws(Tensor.Broadcast.Error) {
        let s = rank2Shape(2, 3)
        let aligned = try Tensor.Broadcast.align(s, s)
        #expect(aligned.dims[0] == Cardinal(2))
        #expect(aligned.dims[1] == Cardinal(3))
    }

    @Test
    func `broadcast align with unit axis expands to other operand`() throws(Tensor.Broadcast.Error)
    {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = .one
        dimsA[1] = Cardinal(3)
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = Cardinal(2)
        dimsB[1] = Cardinal(3)
        let a = Tensor.Shape<2>(dimsA)
        let b = Tensor.Shape<2>(dimsB)
        let aligned = try Tensor.Broadcast.align(a, b)
        #expect(aligned.dims[0] == Cardinal(2))
        #expect(aligned.dims[1] == Cardinal(3))
    }
}

// MARK: - Edge Case Tests

extension `Tensor Value Operations Tests`.`Edge Case` {
    @Test
    func `matmul with incompatible inner dim throws incompatibleShapes`() throws {
        let aShape = rank2Shape(2, 3)
        let bShape = rank2Shape(4, 2)  // inner dim 3 ≠ 4
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: aShape,
            elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: bShape,
            elements: [1, 2, 3, 4, 5, 6, 7, 8]
        )

        do throws(Tensor.Broadcast.Error) {
            _ = try a.multiplied(by: b)
            #expect(Bool(false), "Expected throw")
        } catch let error {
            switch error {
            case .incompatibleShapes:
                break

            default:
                #expect(Bool(false), "Wrong error variant")
            }
        }
    }

    @Test
    func `reshape with mismatched product throws productNotPreserved`() throws {
        let shape = rank2Shape(2, 3)
        let a = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4, 5, 6]
        )
        let wrong = rank2Shape(2, 4)
        do throws(Tensor.Reshape.Error) {
            _ = try a.reshape(to: wrong)
            #expect(Bool(false), "Expected throw")
        } catch let error {
            #expect(error == .productNotPreserved(from: Cardinal(6), to: Cardinal(8)))
        }
    }

    @Test
    func `broadcast align on incompatible non-unit dims throws incompatibleShapes`() {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = Cardinal(2)
        dimsA[1] = Cardinal(3)
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = Cardinal(2)
        dimsB[1] = Cardinal(5)
        let a = Tensor.Shape<2>(dimsA)
        let b = Tensor.Shape<2>(dimsB)

        do throws(Tensor.Broadcast.Error) {
            _ = try Tensor.Broadcast.align(a, b)
            #expect(Bool(false), "Expected throw")
        } catch let error {
            switch error {
            case .incompatibleShapes:
                break

            default:
                #expect(Bool(false), "Wrong error variant")
            }
        }
    }
}
