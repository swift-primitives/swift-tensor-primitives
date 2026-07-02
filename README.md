# Tensor Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-primitives/swift-tensor-primitives/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-primitives/swift-tensor-primitives/actions/workflows/ci.yml)

A runtime-shape n-dimensional tensor whose rank lives at the type level — `Tensor.Value<Element, Rank, Layout>` fixes rank as a compile-time value generic while per-axis sizes stay runtime values, owns its heap storage as a move-only value, and reports every shape, index, broadcast, reshape, and slice failure as a typed error instead of trapping.

The package provides the addressing, layout, broadcast, storage, and view machinery plus naive arithmetic kernels (element-wise with broadcast, rank-2 matmul, whole-tensor reductions). Accelerated kernels — BLAS dispatch, transcendental element-wise, FFT, einsum — are deliberately out of scope; this package is the correctness-first substrate they build on.

---

## Key Features

- **Compile-time rank, runtime shape** — rank is a value generic, so passing a rank-2 tensor where rank-3 is expected is a compile error; per-axis sizes are runtime `Cardinal` values in `Tensor.Shape<Rank>`.
- **Move-only ownership** — the tensor owns its storage outright (`~Copyable`); data is shared through lifetime-bound views (`Tensor.View`, `Tensor.View.Mutable`), never silently copied.
- **Typed errors, no traps** — element access, construction, broadcast, reshape, and slice each throw their own small error enum; no `any Error` and no trapping subscripts.
- **Layout witnesses** — row-major, column-major, and strided layouts are compile-time witness types (`Tensor.Layout.Order.Row`, `Tensor.Layout.Order.Column`, `Tensor.Layout.Strided`), so stride math dispatches with no runtime layout tag.
- **Broadcast arithmetic** — element-wise `adding` / `subtracting` / `multiplying` with shape alignment, naive rank-2 `multiplied(by:)`, and `sum` / `product` / `minimum` / `maximum` reductions.
- **Rank-erased and axis-named variants** — `Tensor.Dynamic.Value<Element>` when rank is only known from data; `Tensor.Named<Element, each Axis>` binds a parameter pack of axis tags.

---

## Quick Start

```swift
import Tensor_Primitives

// Rank is a type-level value generic; per-axis sizes are runtime values.
var dims = InlineArray<2, Cardinal>(repeating: .zero)
dims[0] = Cardinal(2); dims[1] = Cardinal(3)
let shape = Tensor.Shape<2>(dims)

// The tensor owns its heap storage outright — it moves, it never silently copies.
let matrix = try Tensor.Value<Int, 2, Tensor.Layout.Order.Row>(
    shape: shape,
    elements: [1, 2, 3, 4, 5, 6]
)

// Element access is bounds-checked and stride-linearized; failure is a typed
// error (`Tensor.Index.Error.outOfBounds`), not a trap.
var position = InlineArray<2, Ordinal>(repeating: Ordinal(0))
position[0] = Ordinal(1); position[1] = Ordinal(2)
let element = try matrix.element(at: Tensor.Index.Position<2>(position))   // 6

// Element-wise arithmetic aligns shapes by broadcast; a rank mismatch is a
// compile error, a shape mismatch a typed error.
let doubled = try matrix.adding(matrix)
let total = doubled.sum()                                                  // 42
```

---

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-tensor-primitives.git", branch: "main")
]
```

Add a product to your target:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Tensor Primitives", package: "swift-tensor-primitives")
    ]
)
```

The package is pre-1.0 — depend on `branch: "main"` until `0.1.0` is tagged. Requires Swift 6.3 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the corresponding Linux / Windows toolchain).

---

## Architecture

| Product | Contents | When to import |
|---------|----------|----------------|
| `Tensor Primitives` | Umbrella — fixed-rank `Tensor.Value`, the addressing / layout / broadcast machinery, and both variants below | Most consumers |
| `Tensor Dynamic Primitives` | `Tensor.Dynamic.Value<Element>` and `Tensor.Dynamic.Shape` — rank erased to a runtime array of cardinalities | Rank arrives with the data (file formats, model loaders) |
| `Tensor Named Primitives` | `Tensor.Named<Element, each Axis>` — axes are a parameter pack of tag types | APIs where naming axes beats numbering them |
| `Tensor Primitives Test Support` | Test scaffolding re-exports | Test targets only |

---

## Error Handling

Each throwing surface throws exactly one small error enum, so every `catch` is exhaustive at the call site:

| Error | Thrown by | Cases |
|-------|-----------|-------|
| `Tensor.Shape<Rank>.Error` | element-list construction | `.elementCountMismatch`, `.unexpectedScalarShape`, `.zeroDimensionForbidden` |
| `Tensor.Index.Error` | `element(at:)` | `.outOfBounds`, `.rankMismatch` |
| `Tensor.Broadcast.Error` | `adding` / `subtracting` / `multiplying` / `multiplied(by:)` | `.incompatibleShapes`, `.rankMismatch` |
| `Tensor.Reshape.Error` | `reshape(to:)` | `.productNotPreserved`, `.notContiguous` |
| `Tensor.Slice.Error` | slice specification | `.invalidRange`, `.axisOutOfRange` |

```swift
do throws(Tensor.Broadcast.Error) {
    let sum = try lhs.adding(rhs)
} catch .incompatibleShapes(let axis, let lhs, let rhs) {
    // Non-unit lengths differ on `axis`.
} catch .rankMismatch(let lhs, let rhs) {
    // Operand ranks differ.
}
```

---

## Related Packages

- [`swift-buffer-primitives`](https://github.com/swift-primitives/swift-buffer-primitives) — the heap-backed linear buffer the tensor owns its elements in.
- [`swift-cardinal-primitives`](https://github.com/swift-primitives/swift-cardinal-primitives) — the typed cardinality carried per axis in `Tensor.Shape`.
- [`swift-ordinal-primitives`](https://github.com/swift-primitives/swift-ordinal-primitives) — the typed position carried per axis in `Tensor.Index.Position`.

---

## Community

<!-- BEGIN: discussion -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
