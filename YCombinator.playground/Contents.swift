//: Playground - noun: a place where people can play

typealias F = (UInt) -> UInt
typealias FI = (@escaping F) -> F
typealias FS = (@escaping FI) -> F

let f_partial: FI = { factorial in { n in
  n == 0 ? 1 : n * factorial(n - 1)
  }
}

func test(_ factorial: F, i: String = "") {
  assert(factorial(0) == 1)
  assert(factorial(1) == 1)
  assert(factorial(5) == 120)
  print("Succeed \(i)")
}

// V1 - naive

func recurser_v1(n: UInt) -> UInt {
  return f_partial(recurser_v1)(n)
}

let factorial_v1 = recurser_v1
test(factorial_v1, i: "V1")

// V2 - f_partial parameterized

func recurser_v2(_ f: @escaping FI) -> F {
  return { f(recurser_v2(f))($0) }
}

let factorial_v2 = recurser_v2(f_partial)
test(factorial_v2, i: "V2")

// V3 - generalization

func yComb_notReally<T, U>(_ f: @escaping ( @escaping (T) -> U) -> (T) -> U) -> (T) -> U {
  return { f(yComb_notReally(f))($0) }
}
let factorial_v3 = yComb_notReally(f_partial)
test(factorial_v3, i: "V3")
// we can't progress further without breaking types, so..


// screw the type system!

// infinite recursion

let inf_rec: (Any) -> () = {(f) in
  let cast = f as! (Any) -> ()
  cast(f)
}

// Uncoment this to fall to infinite recursion without using excplicit recursion
//inf_rec(inf_rec)

// V3 – recurser parameterized

let recurser_v3: (Any) -> F = { (f) in
  return f_partial { (n) in
    let cast = f as! (Any) -> F
    return cast(f)(n)
  }
}

let factorial_v4 = recurser_v3(recurser_v3) // – holy moly!!
test(factorial_v4, i: "V4")

// Y combinators (real ones)

// Y1 - Remove excplicit f(f) call
let yComb_v1: () -> F = { { (f: Any) in
  let cast = f as! (Any) -> F
  return cast(f)
  }(recurser_v3)
}

// Y2 - Remove recurser_v3
let factorial_y1 = yComb_v1()
test(factorial_y1, i: "Y1")

let yComb_v2: () -> F = {
  return { (f: Any) -> F in
    let cast = f as! (Any) -> F
    return cast(f)
  }({ (f: Any) -> F in
    return f_partial { (n) in
      let cast = f as! (Any) -> F
      return cast(f)(n)
    }
  })
}
let factorial_y2 = yComb_v2()
test(factorial_y2, i: "Y2")

// Y3 - f_partial parameterized
let yComb_v3: FS = {(le) in
  return { (f: Any) -> F in
    let cast = f as! (Any) -> F
    return cast(f)
  }({ (f: Any) -> F in
    return le { (n) in
      let cast = f as! (Any) -> F
      return cast(f)(n)
    }
  })
}
let factorial_y3 = yComb_v3(f_partial)
test(factorial_y3, i: "Y3")

// Y4 - generalize

func Y<T, U>(_ le: @escaping ( @escaping (T) -> U) -> (T) -> U) -> (T) -> U {
  typealias F = (T) -> U
  return { (arg: Any) -> F in
    let f = arg as! (Any) -> F
    return f(f)
    }({ (arg: Any) -> F in
      return le { (n) in
        let f = arg as! (Any) -> F
        return f(f)(n)
      }
    })
}

test(Y(f_partial), i: "general Y combinator")

