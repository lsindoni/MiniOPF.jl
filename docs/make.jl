using Documenter, MiniOPF

makedocs(;
    modules=[MiniOPF],
    format=:html,
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/lsindoni/MiniOPF.jl/blob/{commit}{path}#L{line}",
    sitename="MiniOPF.jl",
    authors="Lorenzo Sindoni",
    assets=[],
)

deploydocs(;
    repo="github.com/lsindoni/MiniOPF.jl",
    target="build",
    julia="0.6",
    deps=nothing,
    make=nothing,
)
