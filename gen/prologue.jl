PLUTOBOOK_VERSION_XSTRINGIZE(major, minor, micro) = "v$major.$minor.$micro"
PLUTOBOOK_MAKE_PAGE_MARGINS(top, right, bottom, left) = plutobook_page_margins_t(top, right, bottom, left)
PLUTOBOOK_MAKE_PAGE_SIZE(width, height) =  plutobook_page_size_t(width, height)

PLUTOBOOK_PAGE_SIZE_NAMED(name) = PLUTOBOOK_MAKE_PAGE_SIZE(eval(Symbol("PLUTOBOOK_PAGE_WIDTH_$name")), eval(Symbol("PLUTOBOOK_PAGE_HEIGHT_$name")))