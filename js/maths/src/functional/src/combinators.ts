type Nothing = void | undefined | null
type Primitive = string | number
type NotFunction = Nothing | Primitive | object | Function
type Function2 = (x: Function) => Function
type Function3 = (x: Function) => (y: Function) => Function

// identity
export const I = <T>(x: T): T => x

// constant
export const K = <T>(x: T) => (y: any): T => x

// apply
export const A = (f: Function) => x => f(x)

// thrush
export const T = x => (f: Function) => f(x)

// duplication
export const W = (f: Function2) => (x: Function) => f(x)(x)

// flip
export const C = (f: Function3) => (y: Function) => (x: Function2) => f(x)(y)

// compose
export const B = (f: Function) => (g: Function) => x => f(g(x))

// substitution
export const S = (f: Function2) => (g: Function) => x => f(x)(g(x))

// psi
export const P = (f: Function) => (g: Function) => x => y => f(g(x))(g(y))

// fix-point (strict)
export const Z = (f: Function) => ((g: Function) => g(g))(g => f(x => g(g)(x)))