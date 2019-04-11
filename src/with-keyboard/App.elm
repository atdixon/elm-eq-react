module App exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json exposing (Decoder)
import Scaff exposing (GroceryItem, decoder, ifThen, resultf)
import Set exposing (Set)


type alias Model =
    { items : List GroceryItem, expanded : Set String }


type Msg
    = Toggle GroceryItem
    | Reload
    | GotData { items : List GroceryItem }
    | NoOp


init : { items : List GroceryItem } -> ( Model, Cmd m )
init flags =
    ( { items = flags.items, expanded = Set.empty }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
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

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        (h4 [] [ text "Grocery List" ]
            :: button [ onClick Reload ] [ text "reload" ]
            :: List.map
                (\t ->
                    div [ class "item", onShiftClick <| Toggle t ]
                        [ text t.item
                        , br [] []
                        , ifThen
                            (Set.member t.item model.expanded)
                            (text t.note)
                            (text "")
                        ]
                )
                model.items
        )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


{-| <https://stackoverflow.com/questions/38418573/how-to-detect-shift-enter-in-elm>
-}
onShiftClick : Msg -> Attribute Msg
onShiftClick msg =
    on "click" <|
        (Json.oneOf [ Json.field "shiftKey" Json.bool, Json.lazy (\_ -> Json.fail <| Debug.log "missing bool shift field" "") ]
            |> Json.andThen (\b -> ifThen b (Json.succeed msg) (Json.succeed NoOp))
        )
