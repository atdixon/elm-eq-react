module App exposing (main)

import Browser
import Componentized.ItemComponent as ItemComponent
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Scaff exposing (GroceryItem, decoder, resultf)


type alias Model =
  { items : List ( GroceryItem, ItemComponent.Model ) }


type Msg
  = GroceryItemMsg GroceryItem ItemComponent.Msg
  | Reload
  | GotData { items : List GroceryItem }


init : { items : List GroceryItem } -> ( Model, Cmd m )
init flags =
  ( { items = List.map (\t -> ( t, ItemComponent.init )) flags.items }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GroceryItemMsg item tmsg ->
      ( { model
          | items =
              List.map
                (\( t, tm ) ->
                  if t == item then
                    ( t, ItemComponent.update tmsg tm )
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
      ( { model | items = List.map (\t -> ( t, ItemComponent.init )) data.items }, Cmd.none )


view : Model -> Html Msg
view model =
  div []
    (h4 [] [ text "Grocery List" ]
      :: button [ onClick Reload ] [ text "reload" ]
      :: List.map
          (\( t, tm ) -> Html.map (GroceryItemMsg t) <| ItemComponent.view { item = t } tm)
          model.items
    )


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = \_ -> Sub.none
    , view = view
    }
