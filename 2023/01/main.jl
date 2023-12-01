function twodigit(str::String)
    i_first, i_last = findfirst(isnumeric, str), findlast(isnumeric, str)
    return parse(Int, str[i_first] * str[i_last])
end

function calibration_value(document)
    f = open(document, "r")
    str_list = [line for line = eachline(f)]
    close(f)
    digits = map(twodigit, str_list)
    #return sum(digits)
    println(document, "=", sum(digits))
end

const STRING_NUMBERS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

function str2num(str)
    i = findfirst(str, STRING_NUMBERS)
    return parse(Char, i)
end

function twodigit2(str)
    i_first_digit, i_last_digit = findfirst(isnumeric, str), findlast(isnumeric, str)
    i_first_sdigit, i_last_sdigit = 0, 0
    k_first_sdigit, k_last_sdigit = 0, 0
    for (k, strnum) = enumerate(STRING_NUMBERS)
        contains(str, strnum) || continue

        i_first = findfirst(strnum, str)
        if i_first_sdigit == 0 || i_first[1] < i_first_sdigit
            i_first_sdigit, k_first_sdigit = i_first[1], k
        end

        i_last = findlast(strnum, str)
        if i_last_sdigit == 0 || i_last[1] > i_last_sdigit
            i_last_sdigit, k_last_sdigit = i_last[1], k
        end
    end

    if i_first_sdigit == 0
        i_first_sdigit = i_first_digit + 1
    end

    first_number  = i_first_digit < i_first_sdigit ? parse(Int, str[i_first_digit]) : k_first_sdigit
    second_number = i_last_digit  > i_last_sdigit  ? parse(Int, str[i_last_digit])  : k_last_sdigit

    return 10*first_number + second_number
end

function calibration_value2(document)
    f = open(document, "r")
    str_list = [line for line = eachline(f)]
    close(f)

    digits = map(twodigit2, str_list)
    println(document, "=", sum(digits))
end

calibration_value(joinpath(@__DIR__, "example.txt"))
calibration_value(joinpath(@__DIR__, "input.txt"))
calibration_value2(joinpath(@__DIR__, "input.txt"))
