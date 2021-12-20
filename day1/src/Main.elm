module Main exposing (main)
import Html

-- MAIN
main =
        Html.text (Debug.toString answer)

-- INPUT
input: String
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

parsedInput: List Int
parsedInput =
        input
        |> String.lines
        |> List.filterMap String.toInt


-- ANSWER
answer = 
        let
            pairs =
                List.map2 (\num1 num2 -> ( num1, num2 ))
                parsedInput
                (List.drop 1 parsedInput)
        in
        pairs
        |> List.map toDelta
        |> List.filter isIncrease
        |> List.length

type Delta = Increase | Decrease | NoChange

toDelta: ( Int, Int ) -> Delta
toDelta ( first, second ) =
        if second - first > 0 then
                Increase
        else if second - first < 0 then
                Decrease
        else
                NoChange

isIncrease delta =
        delta == Increase
