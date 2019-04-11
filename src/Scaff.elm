module Scaff exposing (Flags, Msg(..), Props, GroceryItem, decoder, ifThen, resultf)

import Json.Decode as Json


type alias Flags =
    { items : List GroceryItem }


type alias Props =
    Flags


type Msg
    = Toggle GroceryItem
    | Reload
    | GotData { items : List GroceryItem }


type alias GroceryItem =
    { item : String, note : String }


resultf msgf res =
    Result.toMaybe res
        |> Maybe.map msgf
        |> Maybe.withDefault (msgf { items = [] })


decoder : Json.Decoder { items : List GroceryItem }
decoder =
    Json.map (\t -> { items = t })
        (Json.field "items"
            (Json.list
                (Json.map2 GroceryItem
                    (Json.field "item" Json.string)
                    (Json.field "note" Json.string)
                )
            )
        )


ifThen cond then_ that =
    case cond of
        True ->
            then_

        False ->
            that
