import {Z} from './combinators'
import {mod} from './basicmaths'

export const gcdTwo = Z(b => a => b => b ? g(b)(mod(a)(b)) : a)