@testset "OPF basics" begin
    g1 = MiniOPF.Generator("1", 0.1)
    g2 = MiniOPF.Generator("2", 0.2)
    l1 = MiniOPF.Line("a", ("1", "2"), 1.0)
    branches = [l1]
    bus_ids = ["1", "2"]
    branch_ids = ["a"]
    generators = [g1, g2]
    g = MiniOPF.Grid(bus_ids, branch_ids, generators, branches)
    load = MiniOPF.Load(["1", "2"], [1, 1])
    @test isempty(symdiff(load.bus_ids, bus_ids))
    @testset "DCOPF" begin
        q = MiniOPF.DCOPF(load, g)
        println(q)

        @testset "Test run_opf options" begin
            out = run_opf(q, options=Dict("foo" => "bar"))
            @test isempty(symdiff(keys(out), ["Type", "Options", "Solution"]))
            @test isa(out["Options"], Associative)
            @test haskey(out["Options"], "foo")
        end

        @testset "Default" begin
            out = run_opf(q)
            @test out["Options"] == "none"
        end
    end
end
