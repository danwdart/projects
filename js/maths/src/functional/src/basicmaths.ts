type Addable = String | Number

export const eq = (a: any) => (b: any) => a === b
export const multiplyTwo = (a: number) => (b: number) => a * b
export const sumTwo = <T extends Addable>(a: T) => (b: T): T => a + b
export const div = (a: number) => (b: number) => a / b
export const mod = (a: number) => (b: number) => a % b
export const cmp = (a: any) => (b: any) => (c: any) => c ? a : b

export const pred = sumTwo(-1)
export const succ = sumTwo(1)
