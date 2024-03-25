exports.arraySlice = function(array, start, end) {
    return Array.prototype.slice.call(array, start, end);
};
exports.arraySort = function(array) {
    return Array.prototype.sort.call(array);
}
