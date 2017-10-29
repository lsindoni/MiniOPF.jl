struct Load
    bus_ids::AbstractVector{String}
    nodal_load::AbstractArray{Real}    # This can be a Vector or a Matrix, for multiple time steps
end
Base.show(io::IO, loads::Load) = print("Nodal load specified at $(loads.bus_ids)")

struct Generator
    bus::String
    id::String
    gtype::String
    price::Real
    startup::Real
    shutdown::Real
    ramp_up::Real
    ramp_down::Real
    upper_limit::Real
    lower_limit::Real
end
Generator(bus, price) = Generator(bus, bus, "default", price, 0.0, 0.0, Inf, Inf, Inf, 0.0)
Base.show(io::IO, g::Generator) = print("Generator $(g.id) of type $(g.gtype) at bus $(g.bus).")

abstract type Branch end

struct Line<:Branch
    branch_id::String
    from_to_bus::Tuple{String,String}
    thermal_limit::Real
end
Base.show(io::IO, l::Line) = print("Line $(l.branch_id), $(l.from_to_bus), with limit $(l.thermal_limit)")

struct Grid
    bus_ids::AbstractVector{String}
    branch_ids::AbstractVector{String}
    generators::AbstractVector{Generator}
    branches::AbstractVector{<:Branch}
    incidence::AxisArray
end
function Grid(bus_ids, branch_ids, generators, branches)
    all_branches = [b.branch_id for b in branches]
    if length(Set(bus_ids)) < length(bus_ids)
        error("Multiply defined bus ids")
    end
    if length(Set(branch_ids)) < length(branch_ids)
        error("Multiply defined branch ids")
    end
    if !isempty(symdiff(all_branches, branch_ids))
        error("Incorrect specification of the branches and branch_ids")
    end
    all_buses = Set()
    for b in branches
        for i in b.from_to_bus
            push!(all_buses, i)
        end
    end
    if !isempty(symdiff(bus_ids, all_buses))
        error("Incorrect specification of buses. The branches and buses contain different identifiers")
    end
    gen_buses = [g.bus for g in generators]
    if !isempty(setdiff(gen_buses, bus_ids))
        error("Some generators have been placed in non-existent buses")
    end

    n_buses = length(all_buses)
    n_branches = length(branch_ids)
    incidence = AxisArray(zeros(n_branches, n_buses), Axis{:branch_id}(branch_ids), Axis{:bus_id}(bus_ids))
    for b in branches
        branch_idx = find(branch_ids .== b.branch_id)[1] # find returns an array
        from_idx = find(bus_ids .== b.from_to_bus[1])[1]
        to_idx = find(bus_ids .== b.from_to_bus[2])[1]
        incidence[branch_idx, from_idx] = -1 # This is immaterial, at the moment.
        incidence[branch_idx, to_idx] = 1
    end

    return Grid(bus_ids, branch_ids, generators, branches, incidence)
end
Base.show(io::IO, g::Grid) = print("Grid with $(length(g.bus_ids)) buses and $(length(g.branch_ids)) branches")
