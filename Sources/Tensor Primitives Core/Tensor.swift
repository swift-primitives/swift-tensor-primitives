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

/// Namespace for runtime-shape n-dimensional tensor primitives.
///
/// The `Tensor` namespace hosts the irreducible value type and its addressing,
/// layout, broadcast, storage, and view machinery. It is the runtime-shape
/// counterpart to the compile-time-shape `Linear.Matrix<R, C>` / `Linear.Vector<N>`
/// in `swift-algebra-linear-primitives`.
///
/// ## Layered Design
///
/// At L1 (this package), the namespace owns:
/// - Addressing: `Tensor.Shape<Rank>`, `Tensor.Strides<Rank>`, `Tensor.Index<Rank>`,
///   `Tensor.Slice<Rank>`, `Tensor.Slice.Axis`, `Tensor.Axis` namespace.
/// - Layout witnesses: `Tensor.Layout.Order.Row`, `Tensor.Layout.Order.Column`,
///   `Tensor.Layout.Strided` + `Tensor.Layout.Protocol`.
/// - Broadcast: `Tensor.Broadcast.align(_:_:)` + `Tensor.Broadcast.Error`.
/// - Storage witnesses: `Tensor.Storage.Owned`, `Tensor.Storage.Aligned`.
/// - The owned value type `Tensor<Element, Rank, Layout>`.
/// - The view types `Tensor.View` (read-only) and `Tensor.View.Mutable` (exclusive-borrowed).
/// - Typed errors per `[API-ERR-001]`.
///
/// At L3 (separate `swift-tensors` package), compositions add transcendental
/// element-wise (libm), FFT, einsum, format styles, and cross-package interop.
public enum Tensor {}
