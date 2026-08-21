import Tensor_Primitives_Test_Support
import Testing

@Suite
struct `Tensor Shape Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Tensor Shape Tests`.Unit {
    @Test
    func `constructs rank-3 shape with given dims`() {
        var dims = InlineArray<3, Cardinal>(repeating: .zero)
        dims[0] = Cardinal(2)
        dims[1] = Cardinal(3)
        dims[2] = Cardinal(4)
        let shape = Tensor.Shape<3>(dims)
        #expect(shape.dims[0] == Cardinal(2))
        #expect(shape.dims[1] == Cardinal(3))
        #expect(shape.dims[2] == Cardinal(4))
    }

    @Test
    func `constructs rank-1 shape`() {
        var dims = InlineArray<1, Cardinal>(repeating: .zero)
        dims[0] = Cardinal(7)
        let shape = Tensor.Shape<1>(dims)
        #expect(shape.dims[0] == Cardinal(7))
    }
}
