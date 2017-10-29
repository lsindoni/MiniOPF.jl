@testset "Element constructors" begin

    g1 = MiniOPF.Generator("1", 0.1)
    g2 = MiniOPF.Generator("2", 0.2)
    g3 = MiniOPF.Generator("3", 0.3)
    println(g1)

    l1 = MiniOPF.Line("a", ("1", "2"), 1.0)
    l2 = MiniOPF.Line("b", ("2", "3"), 1.0)
    println(l1)

    bus_ids = ["1", "2"]
    bus_ids_e = ["1", "2", "3"]
    bus_ids_e2 = ["1", "1", "2"]

    branch_ids = ["a"]
    branch_ids_e = ["a", "b"]
    branch_ids_e2 = ["a", "b", "b"]

    generators = [g1, g2]
    generators_e = [g1, g2, g3]

    branches = [l1]
    branches_e = [l1, l2]
    @testset "Generators" begin
        gen_fields = [:bus, :id, :gtype, :price, :startup, :shutdown, :ramp_up, :ramp_down, :upper_limit, :lower_limit]
        @test isempty(symdiff(fieldnames(g1), gen_fields))
    end
    @testset "Branches" begin
        lin_fields = [:branch_id, :from_to_bus, :thermal_limit]
        @test isempty(symdiff(fieldnames(l1), lin_fields))
    end

    @testset "Grid" begin
        g = MiniOPF.Grid(bus_ids, branch_ids, generators, branches)
        println(g)
        grid_fields = [:bus_ids, :branch_ids, :generators, :branches, :incidence]
        @test isempty(symdiff(fieldnames(g), grid_fields))

        @test try MiniOPF.Grid(bus_ids_e, branch_ids, generators, branches) catch true end
        @test try MiniOPF.Grid(bus_ids, branch_ids_e, generators, branches) catch true end
        @test try MiniOPF.Grid(bus_ids, branch_ids, generators_e, branches) catch true end
        @test try MiniOPF.Grid(bus_ids, branch_ids, generators, branches_e) catch true end
        @test try MiniOPF.Grid(bus_ids_e2, branch_ids, generators, branches_e) catch true end
        @test try MiniOPF.Grid(bus_ids, branch_ids_e2, generators, branches_e) catch true end
    end

    @testset "Load" begin
        load = MiniOPF.Load(bus_ids, [1, 1])
        println(load)
        @test isempty(symdiff(fieldnames(load), [:bus_ids, :nodal_load]))
    end

end
