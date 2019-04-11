module Componentized.ItemComponent
  exposing
    ( Model
    , Msg
    , init
    , update
    , view
    )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Scaff exposing (ifThen)


type Model
  = Model { expanded : Bool }


type Msg
  = Toggle


init =
  Model { expanded = False }


update msg (Model model) =
  case msg of
    Toggle ->
      Model { model | expanded = not model.expanded }


view { item } (Model model) =
  div [ class "item", onClick Toggle ]
    [ text item.item
    , br [] []
    , ifThen model.expanded (text item.note) (text "")
    ]
