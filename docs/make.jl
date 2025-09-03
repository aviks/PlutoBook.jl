using PlutoBook
using Documenter

DocMeta.setdocmeta!(PlutoBook, :DocTestSetup, :(using PlutoBook); recursive=true)

makedocs(;
    modules=[PlutoBook],
    authors="Avik Sengupta <avik@sengupta.net> and contributors",
    sitename="PlutoBook.jl",
    format=Documenter.HTML(;
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
