using PlutoBook
using Documenter

DocMeta.setdocmeta!(PlutoBook, :DocTestSetup, :(using PlutoBook); recursive=true)

makedocs(;
    modules=[PlutoBook],
    authors="Avik Sengupta and contributors",
    sitename="PlutoBook.jl",
    repo = GitHub("aviks", "PlutoBook.jl"),
    format=Documenter.HTML(;
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API" => "api.md",
        "CLI Tools" => "cli.md",
    ],
)
