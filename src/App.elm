module App exposing (..)

import Geolocation
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


---- MODEL ----


type alias Model =
    { message : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Elm Geolocation!" }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | DisplayLocation
    | FetchLocation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        DisplayLocation ->
            ( model, Cmd.none )

        FetchLocation ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewMessage model
        ]


viewMessage : Model -> Html Msg
viewMessage { message } =
    h1 [] [ text message ]



---- PROGRAM ----


main : Program String Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
