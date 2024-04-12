exports.arraySlice = function(array, start, end) {
    return Array.prototype.slice.call(array, start, end);
};

exports.sortedArray = function(array) {
    return array.sort();
}
