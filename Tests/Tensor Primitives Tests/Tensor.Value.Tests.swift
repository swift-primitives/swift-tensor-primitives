import Tensor_Primitives_Test_Support
import Testing

@Suite
struct `Tensor Value Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Tensor Value Tests`.Unit {
    @Test
    func `constructs row-major rank-2 tensor from elements`() throws(Tensor.Shape<2>.Error) {
        var dims = InlineArray<2, Cardinal>(repeating: .zero)
        dims[0] = Cardinal(2)
        dims[1] = Cardinal(3)
        let shape = Tensor.Shape<2>(dims)
        let tensor = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4, 5, 6]
        )
        #expect(tensor.shape.dims[0] == Cardinal(2))
        #expect(tensor.shape.dims[1] == Cardinal(3))
    }

    @Test
    func `subscript reads correct elements at row-major positions`() throws {
        var dims = InlineArray<2, Cardinal>(repeating: .zero)
        dims[0] = Cardinal(2)
        dims[1] = Cardinal(3)
        let shape = Tensor.Shape<2>(dims)
        let tensor = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [10, 20, 30, 40, 50, 60]
        )

        for (i, j, expected) in [(0, 0, 10), (0, 2, 30), (1, 0, 40), (1, 2, 60)] {
            var positions = InlineArray<2, Ordinal>(repeating: Ordinal(0))
            positions[0] = Ordinal(UInt(i))
            positions[1] = Ordinal(UInt(j))
            let pos = Tensor.Index.Position<2>(positions)
            let value = try tensor.element(at: pos)
            #expect(value == expected)
        }
    }
}

extension `Tensor Value Tests`.`Edge Case` {
    @Test
    func `mismatched element count throws elementCountMismatch`() {
        var dims = InlineArray<2, Cardinal>(repeating: .zero)
        dims[0] = Cardinal(2)
        dims[1] = Cardinal(3)
        let shape = Tensor.Shape<2>(dims)

        do throws(Tensor.Shape<2>.Error) {
            _ = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
                shape: shape,
                elements: [1, 2, 3]
            )
            #expect(Bool(false), "Expected throw")
        } catch let error {
            #expect(error == .elementCountMismatch(expected: Cardinal(6), actual: Cardinal(3)))
        }
    }

    @Test
    func `out-of-bounds position throws outOfBounds`() throws(Tensor.Shape<2>.Error) {
        var dims = InlineArray<2, Cardinal>(repeating: .zero)
        dims[0] = Cardinal(2)
        dims[1] = Cardinal(3)
        let shape = Tensor.Shape<2>(dims)
        let tensor = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
            shape: shape,
            elements: [1, 2, 3, 4, 5, 6]
        )

        var positions = InlineArray<2, Ordinal>(repeating: Ordinal(0))
        positions[0] = Ordinal(5)
        positions[1] = Ordinal(0)
        let pos = Tensor.Index.Position<2>(positions)

        do throws(Tensor.Index.Error) {
            _ = try tensor.element(at: pos)
            #expect(Bool(false), "Expected throw")
        } catch let error {
            switch error {
            case .outOfBounds:
                break

            default:
                #expect(Bool(false), "Wrong error variant")
            }
        }
    }
}
