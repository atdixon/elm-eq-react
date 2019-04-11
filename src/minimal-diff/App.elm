module App exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Scaff exposing (..)
import Set exposing (Set)


heading =
    h4 [] [ text "Grocery List" ]


item item_ expanded =
    div [ class "item", onClick <| Toggle item_ ]
        [ text item_.item
        , br [] []
        , ifThen expanded (text item_.note) (text "")
        ]


init : Props -> { items : List GroceryItem, expanded : Set String }
init { items } =
    { items = items, expanded = Set.empty }


view { items, expanded } =
    div [] <|
        heading
            :: button [ onClick Reload ] [ text "reload" ]
            :: List.map
                (\t -> item t <| Set.member t.item expanded)
                items


update msg model =
    case msg of
        Toggle t ->
            ( { model
                | expanded =
                    ifThen (Set.member t.item model.expanded)
                        (Set.remove t.item model.expanded)
                        (Set.insert t.item model.expanded)
              }
            , Cmd.none
            )

        Reload ->
            ( model
            , Http.get
                { url = "/data-remote.json"
                , expect = Http.expectJson (resultf GotData) decoder
                }
            )

        GotData data ->
            ( { model | items = data.items }, Cmd.none )


main =
    Browser.element
        { init = \flags -> ( init flags, Cmd.none )
        , update = \msg model -> update msg model
        , subscriptions = \_ -> Sub.none
        , view = view
        }
