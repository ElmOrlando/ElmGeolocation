port module App exposing (..)

import Geolocation exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Task


---- MODEL ----


type alias Loc =
    { lat : Float, lng : Float }


type alias Model =
    { message : String
    , displayLocation : Bool
    , locations : List Loc
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Elm Geolocation!"
      , displayLocation = False
      , locations = []
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = NoOp
    | ToggleLocationDisplay
    | FetchLocation
    | UpdateLocation (Result Geolocation.Error Location)
    | UpdateMovement String


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
            let
                newLocations =
                    Loc location.latitude location.longitude :: model.locations
            in
            ( { model | locations = newLocations }
            , whereami newLocations
            )

        UpdateLocation (Err error) ->
            let
                _ =
                    Debug.log "LocationUpdated" error
            in
            ( model, Cmd.none )

        UpdateMovement keyCode ->
            case List.head model.locations of
                Just location ->
                    let
                        updatedLocations =
                            applyMovement keyCode location :: model.locations
                    in
                    ( { model | locations = updatedLocations }
                    , whereami updatedLocations
                    )

                other ->
                    ( model, Cmd.none )


applyMovement : String -> Loc -> Loc
applyMovement keyCode { lat, lng } =
    case keyCode of
        "KeyW" ->
            Loc (lat + 0.01) lng

        "KeyS" ->
            Loc (lat - 0.01) lng

        "KeyA" ->
            Loc lat (lng - 0.01)

        "KeyD" ->
            Loc lat (lng + 0.01)

        other ->
            Loc lat lng



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ viewMessage model
        , viewLocationToggleButton
        , viewFetchLocationButton
        , if model.displayLocation then
            div []
                [ viewLocationData model
                ]
          else
            div [] []
        ]


viewMessage : Model -> Html Msg
viewMessage { message } =
    h3 [] [ text message ]


viewLocationToggleButton : Html Msg
viewLocationToggleButton =
    button [ onClick ToggleLocationDisplay ] [ text "Toggle Location Display" ]


viewFetchLocationButton : Html Msg
viewFetchLocationButton =
    button [ onClick FetchLocation ] [ text "Fetch Location" ]


viewLocationData : Model -> Html Msg
viewLocationData { locations } =
    p []
        [ locations
            |> List.head
            |> toString
            |> text
        ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Geolocation.changes (UpdateLocation << Ok)
        , newMovement UpdateMovement
        ]


port whereami : List Loc -> Cmd msg


port newMovement : (String -> msg) -> Sub msg



---- PROGRAM ----


main : Program String Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
