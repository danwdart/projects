import {B} from './combinators'

//export const curry = f => (first, ...args) => args.length ? curry(f => g => )
export const get = x => y => y[x]
export const map = f => x => x.map(f)
export const reduce = f => x => y => y.reduce((z, w) => f(z)(w), x) // curried
export const filter = f => x => x.filter(f)
// tsc hates fill
export const arrayOf = <T>(x: T) => (y: number): (Array<T>) => Array.apply(null, Array(y)).map(() => x)

export const pluck = B(map)(get)