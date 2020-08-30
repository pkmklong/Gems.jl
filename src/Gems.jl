__precompile__()


module Gems
using DataFrames
using CSV
#using DataFramesMeta


export gems


function set_map_type(df,
        flag_type:: String)
        return df[df[Symbol(flag_type)] .!= "0", :]
end


function gems(icd_code:: String;
        map_to:: String = "icd10",
        flag_type:: String = "",
        show_flags:: Bool = false)

    if map_to == "icd10"
        df = CSV.File("gems9_10.csv") |> DataFrame
    elseif map_to == "icd9"
        df = CSV.File("gems10_9.csv") |> DataFrame
    end

    if length(flag_type) > 0

        df = set_map_type(df,flag_type)
    end

    if show_flags

        my_query = df[df[:source] .== icd_code, names(df)]

#         my_query = @linq df |>
#             where(:source .== icd_code) |>
#             select(names(df))

    else

        my_query = df[df[:source] .== icd_code,
            [:source,:target,:descriptions ]]

#         my_query = @linq df |>
#                 where(:source .== icd_code) |>
#                 select(:source,
#                     :target,
#                     :descriptions)
    end

    return my_query

end


end
