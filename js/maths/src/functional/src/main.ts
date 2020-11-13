import {B} from './combinators'
import {multiplyTwo} from './basicmaths'
import { arrayOf } from './objects_arrays';

// const randomDieThrow = B(B)(B)(Math.ceil)(multiplyTwo),

const sum = (arr: number[]) => arr.reduce((t, n) => t + n),
    arrayOfBlanks = arrayOf(0),
    zeta = arrayOfBlanks(500).map(
        () => arrayOfBlanks(3).map(
            () => Math.ceil(6 * Math.random())
        )
    ).map(sum)

// Composed
export const main = B(B)(B)(console.log)(zeta)