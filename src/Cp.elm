module Cp exposing (main)

import Browser
import Browser.Dom exposing (getViewport, Viewport)
import Browser.Events as E
import Browser.Navigation as Nav
import Html exposing (a, br, button, div, footer, header, Html, h1, h2, li, nav, section, text, ul)
import Html.Attributes exposing (href, class, width, height, style, id)
import Html.Events exposing (onClick, onMouseOver)
import Url
import WebGL exposing (Mesh, Shader)
import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector3 exposing (vec3, Vec3)
import Task

-- MAIN


main : Program () Model Msg
main =
  Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }



-- MODEL


type alias Model =
  { key : Nav.Key
  , url : Url.Url
  , t : Float
  , window : Window
  , zoomedIn : Bool
  , overlay : String
  , selected : String
  -- , lastSelected :
  -- , others
  }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key=
    ( Model key url 0 { width = 10, height = 10 } True "" "title", Task.perform GotViewport getViewport)


type alias Window =
  { width : Float
  , height : Float
  }



-- UPDATE


type Msg
  = LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | Animate Float
  | WindowSizeChanged Int Int
  | GotViewport Viewport
  | ZoomOut
  | Overlay String
  | Select String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    UrlChanged url ->
      ( { model | url = url }
      , Cmd.none
      )
    
    Animate dt ->
      ( { model | t = model.t + (dt * 500) / 10000 }
      , Cmd.none
      )

    WindowSizeChanged w h ->
      ( { model | window = { width = toFloat w, height = toFloat h } }
      , Cmd.none
      )

    GotViewport viewport ->
      ( { model | window = { width = viewport.scene.width, height = viewport.scene.height } }
      , Cmd.none)
    
    ZoomOut ->
      ( { model | zoomedIn = False }
      , Cmd.none
      )
    
    Overlay name ->
      ( { model | overlay = name }
      , Cmd.none
      )
    
    Select name ->
      ( { model | selected = name }
      , Cmd.none
      )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.batch
  [ E.onAnimationFrameDelta Animate, Sub.none
  , E.onResize (\w h -> WindowSizeChanged w h)
  ]


-- VIEW

-- , text "The URL is: "
-- , b [] [ text (Url.toString model.url) ]

-- selectedToClass : String -> String -> String
-- selectedToClass selected name =
--   if selected == name then "selected"
--   else if selected == "" then "nothingSelected"
--   else "otherSelected"


-- project : Model -> String -> Html Msg
-- project model name =
--   div [ id name, class ("flex-item " ++ selectedToClass model.selected name), onMouseOver (Overlay name), onClick (Select name)]
--         [ header [ class "title" ]
--           [ h1 [] [ text "Project" ]
--           ]
--         , WebGL.toHtml
--           [ width (round model.window.width - 50)
--           , height (round model.window.height - 50)
--           ]
--           [ WebGL.entity
--               vertexShader
--               fragmentShader
--               mesh
--               { perspective = perspective (model.t / 1000) }
--           ]
--         , if model.overlay == name then
--             div [ class "overlay" ]
--               [ WebGL.toHtml
--                 [ width (round model.window.width)
--                 , height (round model.window.height)
--                 ]
--                 [ WebGL.entity
--                     xVertexShader
--                     xFragmentShader
--                     xMesh
--                     { perspective = perspective (turns (1/4)) }
--                 ]
--               ]
--           else
--             div [] []
--         ]


-- title model =
--   div [ class "flex-item selected" ]
--     [ header [ class "title" ]
--       [ h1 [] [ text "Haploid" ]
--       , h2 [] [ text "Robotically Aided Design" ]
--       ]
--     , footer
--       [ class "enter-container" ]
--       [ button [ onClick (Select "") ] [ text "Enter"]
--       ]
--     , WebGL.toHtml
--       [ width (round model.window.width - 50)
--       , height (round model.window.height - 50)
--       ]
--       [ WebGL.entity
--           vertexShader
--           fragmentShader
--           mesh
--           { perspective = perspective (model.t / 1000) }
--       ]
--     ]


-- t model =
--    div [ class "flex-item title-nothingSelected" ]
--       [ header [ class "title" ]
--         [ h1 [] [ text "Haploid" ]
--         , h2 [] [ text "Robotically Aided Design" ]
--         ]
--       , footer
--         [ class "enter-container" ]
--         [ button [ class "button-invis", onClick ZoomOut ] [ text "Enter"]
--         ]
--       , WebGL.toHtml
--         [ width (round model.window.width - 50)
--         , height (round model.window.height - 50)
--         ]
--         [ WebGL.entity
--             vertexShader
--             fragmentShader
--             mesh
--             { perspective = perspective (model.t / 1000) }
--         ]
--       ]
 


-- projectsScreen : Model -> List (Html Msg)
-- projectsScreen model =
--   [ div [ class "flex-container" ]
--     [ div [ class "row" ]
--       [ title model
--       , project model "section0"
--       , project model "section1"
--       , project model "section2"
--       ]
--     ]
--   , div [ class "bottom-info" ]
--     [ text "@ Haploid 2020 - Brookyln, NY" ]
--   ]


-- [ nav []
--   [ section [ class "title" ]
--     [ h1 []
--       [ a
--         [ href "home" ] [ text "noah trueblood" ]
--       ]
--     ]
--   , section []
--     [ ul []
--       [ viewPageLink "projects"
--       , viewPageLink "about"
--       ]
--     ]
--   ]
-- ]

-- projectOne model =
--   if model.selected == "projectOne" then
--     div [ class "flex-item selected" ]
--       [ header [ class "title" ]
--         [ h1 [] [ text "Haploid" ]
--         , h2 [] [ text "Robotically Aided Design" ]
--         ]
--       , footer
--         [ class "enter-container" ]
--         [ button [ onClick (Select "") ] [ text "Enter"]
--         ]
--       , WebGL.toHtml
--         [ width (round model.window.width - 50)
--         , height (round model.window.height - 50)
--         ]
--         [ WebGL.entity
--             vertexShader
--             fragmentShader
--             mesh
--             { perspective = perspective (model.t / 1000) }
--         ]
--       ]
--   else
--     div [ class "flex-item title-nothingSelected" ]
--       [ header [ class "title" ]
--         [ h1 [] [ text "Haploid" ]
--         , h2 [] [ text "Robotically Aided Design" ]
--         ]
--       , footer
--         [ class "enter-container" ]
--         [ button [ class "button-invis", onClick ZoomOut ] [ text "Enter"]
--         ]
--       , WebGL.toHtml
--         [ width (round model.window.width - 50)
--         , height (round model.window.height - 50)
--         ]
--         [ WebGL.entity
--             vertexShader
--             fragmentShader
--             mesh
--             { perspective = perspective (model.t / 1000) }
--         ]
--       ]


-- projectOneScreen : Model -> List (Html Msg)
-- projectOneScreen model =
--   [ div [ class "title-flex-container" ]
--     [ div [ class "title-row" ]
--       [ projectOne model
--       ]
--     ]
--   ]

title : Model -> Html Msg
title model =
  div []
    [ header [ class "title" ]
      [ h1 [] [ text "Haploid" ]
      , h2 [] [ text "Robotically Aided Design" ]
      ]
    , footer
      [ class "enter-container" ]
      [ button [ onClick (Select "") ] [ text "Enter"]
      ]
    , WebGL.toHtml
      [ width (round model.window.width - 50)
      , height (round model.window.height - 50)
      ]
      [ WebGL.entity
          vertexShader
          fragmentShader
          mesh
          { perspective = perspective (model.t / 1000) }
      ]
    ]

project : Model -> String -> Html Msg
project model name =
  div [ id name ]
    [ header [ class "title" ]
      [ h1 [] [ text "Project" ]
      ]
    , WebGL.toHtml
      [ width (round model.window.width - 50)
      , height (round model.window.height - 50)
      ]
      [ WebGL.entity
          vertexShader
          fragmentShader
          mesh
          { perspective = perspective (model.t / 1000) }
      ]
    , if model.overlay == name then
        div [ class "overlay" ]
          [ WebGL.toHtml
            [ width (round model.window.width)
            , height (round model.window.height)
            ]
            [ WebGL.entity
                xVertexShader
                xFragmentShader
                xMesh
                { perspective = perspective (turns (1/4)) }
            ]
          ]
      else
        div [] []
    ]


viewOne : Model -> List (Html Msg)
viewOne model =
  [ div [ class "title-flex-container"]
    [ div [ class "title-row" ]
      [ div [ class "flex-item" ] [ title model ]
      ]
    ]
  ]


viewAll : Model -> List (Html Msg)
viewAll model =
  [ div [ class "flex-container" ]
    [ div [ class "row" ]
      [ div [ class "flex-item title-nothingSelected", onClick (Select "title") ] [ title model ]
      , div [ id "hello", class "flex-item nothingSelected", onMouseOver (Overlay "hello"), onClick (Select "hello")]
        [ project model "hello" ]
      , div [ id "world", class "flex-item nothingSelected", onMouseOver (Overlay "world"), onClick (Select "world")]
        [ project model "world" ]
      ]
    ]
  , div [ class "bottom-info" ]
      [ text "@ Haploid 2020 - Brookyln, NY" ]
  ]


view : Model -> Browser.Document Msg
view model =
  { title = "Haploid"
  , body =
    if model.selected == "" then viewAll model else viewOne model
    -- if model.selected == "title" then titleScreen model else title model
    -- else if model.selected == "projectOne" then projectOneScreen model
    -- else projectsScreen model
  }


viewPageLink : String -> Html msg
viewPageLink path =
  li []
  [ a
    [ href path ]
    [ text path ]
  ]


perspective : Float -> Mat4
perspective t =
  Mat4.mul
    (Mat4.makePerspective 45 1 0.01 100)
    (Mat4.makeLookAt (vec3 (4 * cos t) 0 (4 * sin t)) (vec3 0 0 0) (vec3 0 1 0))


-- Mesh

type alias Vertex =
  { position : Vec3
  , color : Vec3
  }

size : Float
size = 0.5

smallSize : Float
smallSize = 0.1

p =
  { x = 0
  , y = 0
  , z = 0
  }


position : Float -> Float -> Float -> Vec3
position x y z = vec3 (x + p.x) (y + p.y) (z + p.z)



mesh : Mesh Vertex
mesh =
  WebGL.triangles
    [ ( Vertex (position 0 0 0) (vec3 1 0.5 0.5)
      , Vertex (position size size 0) (vec3 1 0.5 0.5)
      , Vertex (position size -size 0) (vec3 1 0.5 0.5)
      )
      , ( Vertex (position 0 0 0) (vec3 1 0.5 0.5)
      , Vertex (position size -size 0) (vec3 0.5 0.5 0.5)
      , Vertex (position -size -size 0) (vec3 0.5 0.5 0.5)
      )
      , ( Vertex (position 0 0 0) (vec3 1 0.5 0.5)
      , Vertex (position -size -size 0) (vec3 0.5 0.5 0.5)
      , Vertex (position -size size 0) (vec3 0.5 0.5 0.5)
      )
      , ( Vertex (position 0 0 0) (vec3 0.5 0.5 0.5)
      , Vertex (position -size size 0) (vec3 0.5 0.5 0.5)
      , Vertex (position size size 0) (vec3 0.5 0.5 0.5)
      )
    ]


rectangle : Float -> Float -> Float -> Float -> Mesh Float
rectangle v0 v1 v2 v3 =
  WebGL.indexedTriangles [ v0, v1, v2, v3 ] [ ( 0, 1, 2 ), ( 2, 3, 0 ) ]

xMesh : Mesh Vertex
xMesh =
  WebGL.points
    [ Vertex (position 0 0 0) (vec3 1 1 1)
    ]
    -- , Vertex (position smallSize -smallSize 0) (vec3 1 1 1)
    --   , Vertex (position -smallSize -smallSize 0) (vec3 1 1 1)
    --   )
    --   , ( Vertex (position 0 0 0) (vec3 1 1 1)
    --   , Vertex (position -smallSize -smallSize 0) (vec3 1 1 1)
    --   , Vertex (position -smallSize smallSize 0) (vec3 1 1 1)
    --   )
    --   , ( Vertex (position 0 0 0) (vec3 1 1 1)
    --   , Vertex (position -smallSize smallSize 0) (vec3 1 1 1)
    --   , Vertex (position smallSize smallSize 0) (vec3 1 1 1)
    --   )
    -- ]


-- Shaders


type alias Uniforms =
  { perspective : Mat4 }


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
  [glsl|

    attribute vec3 position;
    attribute vec3 color;
    uniform mat4 perspective;
    varying vec3 vcolor;

    void main () {
      gl_Position = perspective * vec4(position, 1);
      vcolor = color;
    }

  |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
  [glsl|
  
    precision mediump float;
    varying vec3 vcolor;

    void main () {
      gl_FragColor = vec4(vcolor, 1.0);
    }

  |]


xVertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
xVertexShader =
  [glsl|

    attribute vec3 position;
    attribute vec3 color;
    uniform mat4 perspective;
    varying vec3 vcolor;

    void main () {
      gl_Position = perspective * vec4(position, 0.5);
      vcolor = color;
    }

  |]



xFragmentShader : Shader {} Uniforms { vcolor : Vec3 }
xFragmentShader =
  [glsl|
  
    precision mediump float;
    varying vec3 vcolor;

    void main () {
      gl_FragColor = vec4(vcolor, 1.0);
    }

  |]
