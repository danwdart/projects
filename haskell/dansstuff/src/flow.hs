import Flow

main = do
    1 |> (+2) |> (+3) |> print
    print <| (+3) <| (+2) <| 1
    print <| (+2) .> (+3) <| 3
    print <| (+2) <. (+3) <| 3
    3 |> (+2) <. (+1) |> print
    3 |> (+2) .> (+1) |> print