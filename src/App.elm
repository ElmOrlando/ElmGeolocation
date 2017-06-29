module App exposing (..)

import Geolocation exposing (Location)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    { message : String
    , displayLocation : Bool
    , location : Maybe Location
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Elm Geolocation!"
      , displayLocation = False
      , location = Nothing
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | ToggleLocationDisplay
    | FetchLocation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleLocationDisplay ->
            ( { model | displayLocation = not model.displayLocation }, Cmd.none )

        FetchLocation ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewMessage model
        , viewLocationToggleButton
        ]


viewMessage : Model -> Html Msg
viewMessage { message } =
    h1 [] [ text message ]


viewLocationToggleButton : Html Msg
viewLocationToggleButton =
    button [ onClick ToggleLocationDisplay ] [ text "Toggle Location Display" ]



---- PROGRAM ----


main : Program String Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
