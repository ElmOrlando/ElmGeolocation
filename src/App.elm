port module App exposing (..)

import Geolocation exposing (Location)
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Task


---- MODEL ----


type alias Loc =
    { lat : Float, lng : Float }


type alias Model =
    { message : String
    , displayLocation : Bool
    , locations : List Loc
    , permits : List Loc
    }


type alias Permit =
    { coordinates : Loc }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Elm Geolocation!"
      , displayLocation = False
      , locations = []
      , permits = []
      }
    , fetchPermits
    )


fetchPermits : Cmd Msg
fetchPermits =
    let
        url =
            "https://data.cityoforlando.net/resource/qe2j-hi3t.json"

        request =
            Http.get url decodePermitResponse
    in
        Http.send HandlePermit request


decodePermitResponse : Decode.Decoder (List Loc)
decodePermitResponse =
    Decode.list
        (Decode.maybe
            (Decode.at [ "location", "coordinates" ]
                (Decode.map2 Loc
                    (Decode.index 1 Decode.float)
                    (Decode.index 0 Decode.float)
                )
            )
        )
        |> Decode.map (List.filterMap identity)



---- UPDATE ----


type Msg
    = NoOp
    | ToggleLocationDisplay
    | FetchLocation
    | UpdateLocation (Result Geolocation.Error Location)
    | UpdateMovement String
    | HandlePermit (Result Http.Error (List Loc))


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
                , whereiam newLocations
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
                        , whereiam updatedLocations
                        )

                other ->
                    ( model, Cmd.none )

        HandlePermit response ->
            case response of
                Err _ ->
                    ( model, Cmd.none )

                Ok permits ->
                    ( { model | permits = permits }
                    , plotPoints permits
                    )


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


port whereiam : List Loc -> Cmd msg


port plotPoints : List Loc -> Cmd msg


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
