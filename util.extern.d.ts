export default interface extern {
  arraySlice: (arr: (readonly (string)[]), start: number, end: number) => (string)[],
  arraySort: (arr: (string)[]) => void,
}
