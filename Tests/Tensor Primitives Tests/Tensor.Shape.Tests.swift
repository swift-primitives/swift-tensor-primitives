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

// `Tensor.Shape<Rank>` is generic, so per [SWIFT-TEST-003] we use the
// parallel-namespace pattern rather than `extension Tensor.Shape { @Suite struct Test {} }`.

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
