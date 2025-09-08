using Clang.Generators
using PlutoBook_jll  # replace this with your jll package

cd(@__DIR__)

include_dir = normpath(PlutoBook_jll.artifact_dir, "include")
plutobook_dir = joinpath(include_dir, "plutobook")

options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()  # Note you must call this function firstly and then append your own flags
push!(args, "-I$include_dir")

#headers = detect_headers(plutobook_dir, args)
headers = [joinpath(plutobook_dir, header) for header in readdir(plutobook_dir) if endswith(header, ".h")]

# create context
ctx = create_context(headers, args, options)

# run generator
build!(ctx)
