## Generate the code using Clang

In this directory: 
```
julia --project=.\Project.toml .\generator.jl
```

### Manual Changes

Replace: `PLUTOBOOK_PAGE_SIZE_NAMED\(([A-Z0-9]*)\)` with:`PLUTOBOOK_PAGE_SIZE_NAMED("$1") `

### Maybe TODO

It is unclear what a good Julian API to this library should be. So currently, we just expose the C API directly. If we decide to build one a high level api, it should be added to the `epilogue.jl` file in this directory, and the package regenrated. 

