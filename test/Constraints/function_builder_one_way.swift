// RUN: %target-typecheck-verify-swift
// RUN: %target-typecheck-verify-swift -debug-constraints > %t.log 2>&1
// RUN: %FileCheck %s < %t.log

enum Either<T,U> {
  case first(T)
  case second(U)
}

@_functionBuilder
struct TupleBuilder {
  static func buildBlock<T1>(_ t1: T1) -> T1 {
    return t1
  }

  static func buildBlock<T1, T2>(_ t1: T1, _ t2: T2) -> (T1, T2) {
    return (t1, t2)
  }
  
  static func buildBlock<T1, T2, T3>(_ t1: T1, _ t2: T2, _ t3: T3)
      -> (T1, T2, T3) {
    return (t1, t2, t3)
  }

  static func buildBlock<T1, T2, T3, T4>(_ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4)
      -> (T1, T2, T3, T4) {
    return (t1, t2, t3, t4)
  }

  static func buildBlock<T1, T2, T3, T4, T5>(
    _ t1: T1, _ t2: T2, _ t3: T3, _ t4: T4, _ t5: T5
  ) -> (T1, T2, T3, T4, T5) {
    return (t1, t2, t3, t4, t5)
  }

  static func buildDo<T>(_ value: T) -> T { return value }
  static func buildIf<T>(_ value: T?) -> T? { return value }

  static func buildEither<T,U>(first value: T) -> Either<T,U> {
    return .first(value)
  }
  static func buildEither<T,U>(second value: U) -> Either<T,U> {
    return .second(value)
  }
}

func tuplify<C: Collection, T>(_ collection: C, @TupleBuilder body: (C.Element) -> T) -> T {
  return body(collection.first!)
}

// CHECK: ---Connected components---
// CHECK-NEXT:  0: $T1 $T2 $T3 $T5 $T6 $T7 $T8 $T10 $T11 $T78 $T79 depends on 2
// CHECK-NEXT:  2: $T13 $T18 $T29 $T43 $T54 $T55 $T56 $T57 $T58 $T59 $T60 $T61 $T62 $T63 $T64 $T65 $T66 $T67 $T69 $T70 $T71 $T72 $T73 $T74 $T75 $T76 $T77 depends on 1, 3, 4, 6, 9
// CHECK-NEXT:  9: $T49 $T50 $T51 $T52 $T53 depends on 8
// CHECK-NEXT:  8: $T44 $T45 $T46 $T47 $T48
// CHECK-NEXT:  6: $T32 $T36 $T37 $T38 $T39 $T40 $T41 $T42 depends on 5, 7
// CHECK-NEXT:  7: $T33 $T34 $T35
// CHECK-NEXT:  5: $T31
// CHECK-NEXT:  4: $T19 $T20 $T21 $T22 $T23 $T24 $T25 $T26 $T27 $T28
// CHECK-NEXT:  3: $T16 $T17
// CHECK-NEXT:  1: $T12
let names = ["Alice", "Bob", "Charlie"]
let b = true
var number = 17
print(
  tuplify(names) { name in
    17
    number
    "Hello, \(name)"
    tuplify(["a", "b"]) { value in
      value.first!
    }
    if b {
      2.71828
      ["if", "stmt"]
    } else {
      [1, 2, 3, 17]
    }
  })
