
public struct YCombinatorFactory<T, U> {
  typealias F =  (T) -> U
  let Y: (@escaping (@escaping F) -> F) -> F
  init() {
    Y = { (le) in
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
  }
}
