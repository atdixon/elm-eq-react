module App exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Scaff exposing (GroceryItem, decoder, ifThen, resultf)



-- TASK COMPONENT (IMAGINE THIS IN ITS OWN FILE w/ T prefixes)


{-| !!! OPAQUE !!!
-}
type TModel
    = TModel { expanded : Bool }


{-| !!! OPAQUE !!!
-}
type TMsg
    = Toggle


t_init =
    TModel { expanded = False }


{-| NOTE OPAQUE ARGS.
-}
t_update msg (TModel model) =
    case msg of
        Toggle ->
            TModel { model | expanded = not model.expanded }


{-| !!! OPAQUE !!!
-}
t_view { item } (TModel model) =
    div [ class "item", onClick Toggle ]
        [ text item.item
        , br [] []
        , ifThen model.expanded (text item.note) (text "")
        ]



-- END TASK COMPONENT


{-| NOTE REFS TO OPAQUE STATE VALUES (and how we have to keep them per item)
-}
type alias Model =
    { items : List ( GroceryItem, TModel ) }


type Msg
    = GroceryItemMsg GroceryItem TMsg
    | Reload
    | GotData { items : List GroceryItem }


init : { items : List GroceryItem } -> ( Model, Cmd m )
init flags =
    ( { items = List.map (\t -> ( t, t_init )) flags.items }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GroceryItemMsg item tmsg ->
            ( { model
                | items =
                    List.map
                        (\( t, tm ) ->
                            if t == item then
                                ( t, t_update tmsg tm )

                            else
                                ( t, tm )
                        )
                        model.items
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
            ( { model | items = List.map (\t -> ( t, t_init )) data.items }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        (h4 [] [ text "Grocery List" ]
            :: button [ onClick Reload ] [ text "reload" ]
            :: List.map
                (\( t, tm ) -> Html.map (GroceryItemMsg t) <| t_view { item = t } tm)
                model.items
        )


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
