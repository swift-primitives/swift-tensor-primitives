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

import Testing
import Tensor_Primitives_Test_Support

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
fileprivate func readElement<Element: Copyable, Layout: Tensor.Layout.`Protocol`>(
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
fileprivate func rank2Shape(_ rows: Int, _ cols: Int) -> Tensor.Shape<2> {
    var dims = InlineArray<2, Cardinal>(repeating: .zero)
    dims[0] = Cardinal(UInt(rows))
    dims[1] = Cardinal(UInt(cols))
    return Tensor.Shape<2>(dims)
}

// MARK: - Unit Tests

extension `Tensor Value Operations Tests`.Unit {
    @Test
    func `element-wise addition produces correct sums`() throws(Tensor.Index.Error) {
        let shape = rank2Shape(2, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4]
        )
        let b = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [10, 20, 30, 40]
        )
        let result = try! a.adding(b)
        #expect(try readElement(from: result, at: 0, 0) == 11)
        #expect(try readElement(from: result, at: 0, 1) == 22)
        #expect(try readElement(from: result, at: 1, 0) == 33)
        #expect(try readElement(from: result, at: 1, 1) == 44)
    }

    @Test
    func `element-wise subtraction produces correct differences`() throws(Tensor.Index.Error) {
        let shape = rank2Shape(2, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [10, 20, 30, 40]
        )
        let b = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4]
        )
        let result = try! a.subtracting(b)
        #expect(try readElement(from: result, at: 0, 0) == 9)
        #expect(try readElement(from: result, at: 1, 1) == 36)
    }

    @Test
    func `scalar multiplication scales every element by the scalar`() throws(Tensor.Index.Error) {
        let shape = rank2Shape(2, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4]
        )
        let result = a.scaled(by: 3)
        #expect(try readElement(from: result, at: 0, 0) == 3)
        #expect(try readElement(from: result, at: 1, 1) == 12)
    }

    @Test
    func `sum reduction returns total across all elements`() {
        let shape = rank2Shape(2, 3)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4, 5, 6]
        )
        #expect(a.sum() == 21)
    }

    @Test
    func `product reduction returns multiplied total`() {
        let shape = rank2Shape(2, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4]
        )
        #expect(a.product() == 24)
    }

    @Test
    func `min and max reductions return extremes`() {
        let shape = rank2Shape(2, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [4, 1, 9, 3]
        )
        #expect(a.minimum() == 1)
        #expect(a.maximum() == 9)
    }

    @Test
    func `transpose swaps axes for rank-2 tensor`() throws(Tensor.Index.Error) {
        let shape = rank2Shape(2, 3)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4, 5, 6]
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
    func `matmul of 2x3 by 3x2 produces 2x2 result`() throws(Tensor.Index.Error) {
        let aShape = rank2Shape(2, 3)
        let bShape = rank2Shape(3, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: aShape, elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: bShape, elements: [7, 8, 9, 10, 11, 12]
        )
        // [[1,2,3],[4,5,6]] · [[7,8],[9,10],[11,12]]
        // = [[1·7+2·9+3·11, 1·8+2·10+3·12],
        //    [4·7+5·9+6·11, 4·8+5·10+6·12]]
        // = [[58, 64], [139, 154]]
        let c = try! a.multiplied(by: b)
        #expect(c.shape.dims[0] == Cardinal(2))
        #expect(c.shape.dims[1] == Cardinal(2))
        #expect(try readElement(from: c, at: 0, 0) == 58)
        #expect(try readElement(from: c, at: 0, 1) == 64)
        #expect(try readElement(from: c, at: 1, 0) == 139)
        #expect(try readElement(from: c, at: 1, 1) == 154)
    }

    @Test
    func `reshape from rank-1 to rank-2 preserves elements`() throws(Tensor.Index.Error) {
        // Start with a rank-1 tensor of 6, reshape to (2,3) then (3,2).
        var dims1 = InlineArray<1, Cardinal>(repeating: .zero)
        dims1[0] = Cardinal(6)
        let shape1 = Tensor.Shape<1>(dims1)
        let a = try! Tensor.Value<Int, 1, Tensor.Layout.Order.Row>(
            shape: shape1, elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try! a.reshape(to: rank2Shape(2, 3))
        #expect(b.shape.dims[0] == Cardinal(2))
        #expect(b.shape.dims[1] == Cardinal(3))
        #expect(try readElement(from: b, at: 0, 0) == 1)
        #expect(try readElement(from: b, at: 1, 2) == 6)

        let c = try! b.reshape(to: rank2Shape(3, 2))
        #expect(c.shape.dims[0] == Cardinal(3))
        #expect(c.shape.dims[1] == Cardinal(2))
        #expect(try readElement(from: c, at: 0, 0) == 1)
        #expect(try readElement(from: c, at: 2, 1) == 6)
    }

    @Test
    func `map applies transform to every element`() throws(Tensor.Index.Error) {
        let shape = rank2Shape(2, 2)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4]
        )
        let doubled: Tensor.Value<Int, 2, Tensor.Layout.Order.Row> =
            a.map { (x: Int) -> Int in x * 2 }
        #expect(try readElement(from: doubled, at: 0, 0) == 2)
        #expect(try readElement(from: doubled, at: 1, 1) == 8)
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
    func `broadcast align with unit axis expands to other operand`() throws(Tensor.Broadcast.Error) {
        var dimsA = InlineArray<2, Cardinal>(repeating: .zero)
        dimsA[0] = .one; dimsA[1] = Cardinal(3)
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = Cardinal(2); dimsB[1] = Cardinal(3)
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
    func `matmul with incompatible inner dim throws incompatibleShapes`() {
        let aShape = rank2Shape(2, 3)
        let bShape = rank2Shape(4, 2) // inner dim 3 ≠ 4
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: aShape, elements: [1, 2, 3, 4, 5, 6]
        )
        let b = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: bShape, elements: [1, 2, 3, 4, 5, 6, 7, 8]
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
    func `reshape with mismatched product throws productNotPreserved`() {
        let shape = rank2Shape(2, 3)
        let a = try! Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape, elements: [1, 2, 3, 4, 5, 6]
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
        dimsA[0] = Cardinal(2); dimsA[1] = Cardinal(3)
        var dimsB = InlineArray<2, Cardinal>(repeating: .zero)
        dimsB[0] = Cardinal(2); dimsB[1] = Cardinal(5)
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
