abstract type Case end


"""

    DCOPF<:Case

# Fields
- `load::Load`: load profile for each time step
- `grid::Grid`: the grid (topology and generation units)

"""
struct DCOPF<:Case
    load::Load
    grid::Grid
end
Base.show(io::IO, q::DCOPF) = print("DCOPF")

"""

    run_opf(case::Case; options::Associative=Dict())

Returns the output of an OPF as specified by the case and options. Returns a dict with

- "Type"
- "Options"
- "Solution"

"""
function run_opf(case::Case; options::Associative=Dict())
    out_dict = Dict(
        "Type" => "$(typeof(case))",
        "Options" =>  length(options) > 0 ? options : "none",
        "Solution" => "None",
    )
    return out_dict
end
