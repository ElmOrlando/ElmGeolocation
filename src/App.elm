module App exposing (..)

import Geolocation exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Task


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
    | UpdateLocation (Result Geolocation.Error Location)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ToggleLocationDisplay ->
            ( { model | displayLocation = not model.displayLocation }, Cmd.none )

        FetchLocation ->
            let
                cmd =
                    Geolocation.now |> Task.attempt UpdateLocation
            in
                ( model, cmd )

        UpdateLocation (Ok location) ->
            ( { model | location = Just location }, Cmd.none )

        UpdateLocation (Err error) ->
            let
                _ =
                    Debug.log "LocationUpdated" error
            in
                ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewMessage model
        , viewLocationToggleButton
        , viewFetchLocationButton
        , if model.displayLocation then
            viewLocationData model
          else
            div [] []
        ]


viewMessage : Model -> Html Msg
viewMessage { message } =
    h1 [] [ text message ]


viewLocationToggleButton : Html Msg
viewLocationToggleButton =
    button [ onClick ToggleLocationDisplay ] [ text "Toggle Location Display" ]


viewFetchLocationButton : Html Msg
viewFetchLocationButton =
    button [ onClick FetchLocation ] [ text "Fetch Location" ]


viewLocationData : Model -> Html Msg
viewLocationData { location } =
    p []
        [ location
            |> toString
            |> text
        ]



---- PROGRAM ----


main : Program String Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
