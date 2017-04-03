/*

Note that the name of your namespace MUST match the names in the repository 
field of your elm-package.json file. For example, if your repository was

https://github.com/ghostman/killer-app.git

and your module was called MountainGoat, then your namespace must be 

_ghostman$killer_app$Native_MountainGoat


*/
var _feihong$elm_examples$Native_MyModule = function() {

function add(a, b, c) {
    return a + b + c;
}

// Based on String.toList defined in:
// https://github.com/elm-lang/core/blob/4.0.1/src/Native/String.js
function stringToList(str) {
    return _elm_lang$core$Native_List.fromArray(Array.from(str).map(_elm_lang$core$Native_Utils.chr));
}

return {
    add: F3(add),
    stringToList: stringToList
};

}();