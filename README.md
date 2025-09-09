# PlutoBook.jl

[![Build Status](https://github.com/aviks/PlutoBook.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/aviks/PlutoBook.jl/actions/workflows/CI.yml?query=branch%3Amain)

A Julia wrapper for the [PlutoBook](https://github.com/plutoprint/plutobook) C++ library - a robust HTML rendering engine that converts HTML/XML content to PDF documents and bitmap images.

## Features

- Custom rendering engine (not based on Chromium/WebKit/Gecko)
- Modern web standards: CSS 3/4, HTML5, XHTML, SVG support
- Multiple output formats: PDF and bitmap images (PNG)
- Flexible page control and custom page sizes
- Memory efficient and optimized for performance

## Installation

```julia
using Pkg
Pkg.add("PlutoBook")
```

## Quick Start

```julia
using PlutoBook

# HTML content
html = """
<!DOCTYPE html>
<html><body>
<h1>Hello PlutoBook!</h1>
<p>Converting HTML to PDF with Julia.</p>
</body></html>
"""

# Create book and render to PDF
book = plutobook_create(PLUTOBOOK_PAGE_SIZE_A4, PLUTOBOOK_PAGE_MARGINS_NORMAL, PLUTOBOOK_MEDIA_TYPE_PRINT)
plutobook_load_html(book, html, -1, "", "", "")
plutobook_write_to_pdf(book, "output.pdf")
plutobook_destroy(book)
```

## Documentation

For detailed usage examples, API reference, and advanced features, see the [documentation](https://aviks.github.io/PlutoBook.jl/).

## License

MIT License. See [LICENSE](LICENSE) for details.