module Main exposing (..)
import Html
input = """
199
200
208
210
200
207
240
269
260
263
"""

-- MAIN
main =
        Html.text (Debug.toString answer) 

input_clean =
        input
        |> String.lines
        |> List.filterMap String.toInt

input_clean_drop1 =
        List.drop 1 input_clean

pairs =
        List.map2 (\x y -> (x, y)) input_clean input_clean_drop1

list_increase =
        List.map2 (\x y -> y > x) input_clean input_clean_drop1

answer = List.filter (\x -> x) list_increase
        |> List.length

        
