var _feihong$elm_examples$Native_Unicode = function() {

function stringToList(str) {
    return _elm_lang$core$Native_List.fromArray(Array.from(str).map(_elm_lang$core$Native_Utils.chr));
}

return {
    stringToList: stringToList
};

}();