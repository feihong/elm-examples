module ListUtil exposing (deleteAt, elementAt, replaceAt, elementWith)


deleteAt : Int -> List a -> List a
deleteAt index list =
    list
        |> indexedFilterMap
            (\i val ->
                if index == i then
                    Nothing
                else
                    Just val
            )


elementAt : Int -> List a -> Maybe a
elementAt index list =
    list
        |> indexedFilterMap
            (\i v ->
                if i == index then
                    Just v
                else
                    Nothing
            )
        |> List.head


replaceAt : Int -> a -> List a -> List a
replaceAt index value list =
    list
        |> List.indexedMap
            (\i v ->
                if i == index then
                    value
                else
                    v
            )


{-| Return the first element (as a Maybe) that matches the given predicate
-}
elementWith : (a -> Bool) -> List a -> Maybe a
elementWith pred list =
    list |> List.filter pred |> List.head


indexedFilterMap : (Int -> a -> Maybe b) -> List a -> List b
indexedFilterMap fn list =
    list |> List.indexedMap fn |> List.filterMap identity
