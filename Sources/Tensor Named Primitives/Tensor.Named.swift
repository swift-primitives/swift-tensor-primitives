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

public import Tensor_Primitives_Core
public import Memory_Heap_Primitives
public import Storage_Contiguous_Primitives

extension Tensor {
    /// A named-axis tensor in the Dex style.
    ///
    /// `Tensor.Named<Element, repeat each Axis>` carries axis identity in the
    /// type pack — `Tensor.Named<Float, Image.Height, Image.Width, RGB.Channel>`
    /// is a different type from `Tensor.Named<Float, RGB.Channel, Image.Height,
    /// Image.Width>`. Each axis conforms to `Tensor.Axis.Protocol` and
    /// contributes its `static var size: Int` to the runtime shape vector.
    ///
    /// Backed by SE-0398 variadic generic types + SE-0393 parameter packs.
    public struct Named<Element: ~Copyable, each Axis: Tensor.Axis.`Protocol`>: ~Copyable {
        /// Per-axis cardinalities recorded from each `Axis.size`.
        @usableFromInline
        package var _dims: [Cardinal]

        /// Heap-backed element storage.
        @usableFromInline
        package var _storage: Buffer<Storage_Primitive.Storage<Element>.Contiguous<Memory.Heap<Element>>>.Linear

        /// Canonical initializer.
        ///
        /// - Parameter storage: Element storage; size MUST equal the product
        ///   of all `each Axis.size`.
        @inlinable
        public init(storage: consuming Buffer<Storage_Primitive.Storage<Element>.Contiguous<Memory.Heap<Element>>>.Linear) {
            var dims: [Cardinal] = []
            for axisSize in repeat (each Axis).size {
                dims.append(Cardinal(UInt(bitPattern: axisSize)))
            }
            self._dims = dims
            self._storage = storage
        }
    }
}
