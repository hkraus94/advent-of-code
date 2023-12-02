using Base: show_supertypes
# in: single draw of the form "3 blue, 4 green, 7 red"
# out: vector corresponding to outcomes
function results_of_draws(draw, outcomes)
    draw_list = map(lstrip, split(draw, ","))
    output    = zeros(Int, length(outcomes))
    for draw = draw_list
        n, outcome = to_int_symb(split(draw, " ")...)
        k = findfirst(==(outcome), outcomes)
        output[k] = n
    end
    return output
end

minimal_cubeset(game) = maximum(game; dims=2)
power_cubeset(cubeset) = *(cubeset...)
to_int_symb(int_str, symb_str) = parse(Int, int_str), Symbol(symb_str)

function is_game_valid(draws, maximum_values)
    for draw = eachcol(draws)
        if any(draw .> maximum_values)
            return false
        end
    end
    return true
end

# in: single line of file "Game 3: 3 blue, 4 green, 7 red; ..." + possible outcome values
function generate_games(line, outcomes)
    id_str, games_str = split(line, ":")

    # get ID of game
    id = parse(Int, id_str[findfirst(isnumeric, id_str):end])

    # store each game
    games_strvec = split(games_str, ";")
    games        = map(game -> results_of_draws(game, outcomes), games_strvec)
    return id, hcat(games...)
end

function main(path; maximum_values)
    lines = readlines(path)

    is_valid = zeros(Bool, length(lines))
    power    = zeros(Int,  length(lines))

    for line = lines
        id, game     = generate_games(line, keys(maximum_values))
        is_valid[id] = is_game_valid(game, values(maximum_values))
        power[id]    = power_cubeset(minimal_cubeset(game))
    end

    println(basename(path), ", ", maximum_values, ": ", "valid=", sum(findall(is_valid)), ", power=", sum(power))

    return
end

main(joinpath(@__DIR__, "example.txt"); maximum_values=(red=12, green=13, blue=14))
main(joinpath(@__DIR__, "input.txt"); maximum_values=(red=12, green=13, blue=14))
