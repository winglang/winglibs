export default interface extern {
  arraySlice: (arr: (readonly (string)[]), start: number, end: number) => (string)[],
  sortedArray: (arr: (readonly (string)[])) => (readonly (string)[]),
}
