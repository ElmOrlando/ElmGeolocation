module Main exposing (..)

import Html exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)


-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( model
    , Cmd.none
    )



-- MODEL


type alias Model =
    {}


model : Model
model =
    {}



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [-- something
        ]



-- PORTS


lat : Float
lat =
    28.5383


lng : Float
lng =
    -81.3792


latlng : ( Float, Float )
latlng =
    ( lat, lng )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ ul []
            [ li [] [ text "First Feature!" ]
            , li [] [ text "Second Feature!!" ]
            , li [] [ text "Third Feature!!!" ]
            , li [] [ text "Fourth Feature!!!!" ]
            ]
        , p [] [ text "Our API key is [Fetchable from https://developers.google.com/maps/]" ]
        ]
