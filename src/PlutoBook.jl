module PlutoBook

using PlutoBook_jll
export PlutoBook_jll

using CEnum: CEnum, @cenum

PLUTOBOOK_VERSION_XSTRINGIZE(major, minor, micro) = "v$major.$minor.$micro"
PLUTOBOOK_MAKE_PAGE_MARGINS(top, right, bottom, left) = plutobook_page_margins_t(top, right, bottom, left)
PLUTOBOOK_MAKE_PAGE_SIZE(width, height) =  plutobook_page_size_t(width, height)

PLUTOBOOK_PAGE_SIZE_NAMED(name) = PLUTOBOOK_MAKE_PAGE_SIZE(eval(Symbol("PLUTOBOOK_PAGE_WIDTH_$name")), eval(Symbol("PLUTOBOOK_PAGE_HEIGHT_$name")))


# https://github.com/JuliaInterop/Clang.jl/issues/556
const PLUTOBOOK_UNITS_CM = Float32(72.0) / Float32(2.54)
const PLUTOBOOK_UNITS_MM = Float32(72.0) / Float32(25.4)
const PLUTOBOOK_UNITS_PX = Float32(72.0) / Float32(96.0)

struct _plutobook_page_size
    width::Cfloat
    height::Cfloat
end

const plutobook_page_size_t = _plutobook_page_size

struct _plutobook_page_margins
    top::Cfloat
    right::Cfloat
    bottom::Cfloat
    left::Cfloat
end

const plutobook_page_margins_t = _plutobook_page_margins

function plutobook_version()
    ccall((:plutobook_version, libplutobook), Cint, ())
end

function plutobook_version_string()
    ccall((:plutobook_version_string, libplutobook), Ptr{Cchar}, ())
end

function plutobook_build_info()
    ccall((:plutobook_build_info, libplutobook), Ptr{Cchar}, ())
end

@cenum _plutobook_stream_status::UInt32 begin
    PLUTOBOOK_STREAM_STATUS_SUCCESS = 0
    PLUTOBOOK_STREAM_STATUS_READ_ERROR = 10
    PLUTOBOOK_STREAM_STATUS_WRITE_ERROR = 11
end

const plutobook_stream_status_t = _plutobook_stream_status

# typedef plutobook_stream_status_t ( * plutobook_stream_write_callback_t ) ( void * closure , const char * data , unsigned int length )
const plutobook_stream_write_callback_t = Ptr{Cvoid}

mutable struct _cairo_surface end

const cairo_surface_t = _cairo_surface

mutable struct _cairo end

const cairo_t = _cairo

mutable struct _plutobook_canvas end

const plutobook_canvas_t = _plutobook_canvas

function plutobook_canvas_destroy(canvas)
    ccall((:plutobook_canvas_destroy, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_flush(canvas)
    ccall((:plutobook_canvas_flush, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_finish(canvas)
    ccall((:plutobook_canvas_finish, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_translate(canvas, tx, ty)
    ccall((:plutobook_canvas_translate, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat), canvas, tx, ty)
end

function plutobook_canvas_scale(canvas, sx, sy)
    ccall((:plutobook_canvas_scale, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat), canvas, sx, sy)
end

function plutobook_canvas_rotate(canvas, angle)
    ccall((:plutobook_canvas_rotate, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat), canvas, angle)
end

function plutobook_canvas_transform(canvas, a, b, c, d, e, f)
    ccall((:plutobook_canvas_transform, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), canvas, a, b, c, d, e, f)
end

function plutobook_canvas_set_matrix(canvas, a, b, c, d, e, f)
    ccall((:plutobook_canvas_set_matrix, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), canvas, a, b, c, d, e, f)
end

function plutobook_canvas_reset_matrix(canvas)
    ccall((:plutobook_canvas_reset_matrix, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_clip_rect(canvas, x, y, width, height)
    ccall((:plutobook_canvas_clip_rect, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat), canvas, x, y, width, height)
end

function plutobook_canvas_clear_surface(canvas, red, green, blue, alpha)
    ccall((:plutobook_canvas_clear_surface, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat), canvas, red, green, blue, alpha)
end

function plutobook_canvas_save_state(canvas)
    ccall((:plutobook_canvas_save_state, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_restore_state(canvas)
    ccall((:plutobook_canvas_restore_state, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_get_surface(canvas)
    ccall((:plutobook_canvas_get_surface, libplutobook), Ptr{cairo_surface_t}, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_canvas_get_context(canvas)
    ccall((:plutobook_canvas_get_context, libplutobook), Ptr{cairo_t}, (Ptr{plutobook_canvas_t},), canvas)
end

@cenum _plutobook_image_format::Int32 begin
    PLUTOBOOK_IMAGE_FORMAT_INVALID = -1
    PLUTOBOOK_IMAGE_FORMAT_ARGB32 = 0
    PLUTOBOOK_IMAGE_FORMAT_RGB24 = 1
    PLUTOBOOK_IMAGE_FORMAT_A8 = 2
    PLUTOBOOK_IMAGE_FORMAT_A1 = 3
end

const plutobook_image_format_t = _plutobook_image_format

function plutobook_image_canvas_create(width, height, format)
    ccall((:plutobook_image_canvas_create, libplutobook), Ptr{plutobook_canvas_t}, (Cint, Cint, plutobook_image_format_t), width, height, format)
end

function plutobook_image_canvas_create_for_data(data, width, height, stride, format)
    ccall((:plutobook_image_canvas_create_for_data, libplutobook), Ptr{plutobook_canvas_t}, (Ptr{Cuchar}, Cint, Cint, Cint, plutobook_image_format_t), data, width, height, stride, format)
end

function plutobook_image_canvas_get_data(canvas)
    ccall((:plutobook_image_canvas_get_data, libplutobook), Ptr{Cuchar}, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_image_canvas_get_format(canvas)
    ccall((:plutobook_image_canvas_get_format, libplutobook), plutobook_image_format_t, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_image_canvas_get_width(canvas)
    ccall((:plutobook_image_canvas_get_width, libplutobook), Cint, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_image_canvas_get_height(canvas)
    ccall((:plutobook_image_canvas_get_height, libplutobook), Cint, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_image_canvas_get_stride(canvas)
    ccall((:plutobook_image_canvas_get_stride, libplutobook), Cint, (Ptr{plutobook_canvas_t},), canvas)
end

function plutobook_image_canvas_write_to_png(canvas, filename)
    ccall((:plutobook_image_canvas_write_to_png, libplutobook), Bool, (Ptr{plutobook_canvas_t}, Ptr{Cchar}), canvas, filename)
end

function plutobook_image_canvas_write_to_png_stream(canvas, callback, closure)
    ccall((:plutobook_image_canvas_write_to_png_stream, libplutobook), Bool, (Ptr{plutobook_canvas_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}), canvas, callback, closure)
end

@cenum _plutobook_pdf_metadata::UInt32 begin
    PLUTOBOOK_PDF_METADATA_TITLE = 0
    PLUTOBOOK_PDF_METADATA_AUTHOR = 1
    PLUTOBOOK_PDF_METADATA_SUBJECT = 2
    PLUTOBOOK_PDF_METADATA_KEYWORDS = 3
    PLUTOBOOK_PDF_METADATA_CREATOR = 4
    PLUTOBOOK_PDF_METADATA_CREATION_DATE = 5
    PLUTOBOOK_PDF_METADATA_MODIFICATION_DATE = 6
end

const plutobook_pdf_metadata_t = _plutobook_pdf_metadata

function plutobook_pdf_canvas_create(filename, size)
    ccall((:plutobook_pdf_canvas_create, libplutobook), Ptr{plutobook_canvas_t}, (Ptr{Cchar}, plutobook_page_size_t), filename, size)
end

function plutobook_pdf_canvas_create_for_stream(callback, closure, size)
    ccall((:plutobook_pdf_canvas_create_for_stream, libplutobook), Ptr{plutobook_canvas_t}, (plutobook_stream_write_callback_t, Ptr{Cvoid}, plutobook_page_size_t), callback, closure, size)
end

function plutobook_pdf_canvas_set_metadata(canvas, metadata, value)
    ccall((:plutobook_pdf_canvas_set_metadata, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, plutobook_pdf_metadata_t, Ptr{Cchar}), canvas, metadata, value)
end

function plutobook_pdf_canvas_set_size(canvas, size)
    ccall((:plutobook_pdf_canvas_set_size, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, plutobook_page_size_t), canvas, size)
end

function plutobook_pdf_canvas_show_page(canvas)
    ccall((:plutobook_pdf_canvas_show_page, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

# typedef void ( * plutobook_resource_destroy_callback_t ) ( void * data )
const plutobook_resource_destroy_callback_t = Ptr{Cvoid}

mutable struct _plutobook_resource_data end

const plutobook_resource_data_t = _plutobook_resource_data

function plutobook_resource_data_create(content, content_length, mime_type, text_encoding)
    ccall((:plutobook_resource_data_create, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}), content, content_length, mime_type, text_encoding)
end

function plutobook_resource_data_create_without_copy(content, content_length, mime_type, text_encoding, destroy_callback, closure)
    ccall((:plutobook_resource_data_create_without_copy, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}, plutobook_resource_destroy_callback_t, Ptr{Cvoid}), content, content_length, mime_type, text_encoding, destroy_callback, closure)
end

function plutobook_resource_data_reference(resource)
    ccall((:plutobook_resource_data_reference, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{plutobook_resource_data_t},), resource)
end

function plutobook_resource_data_destroy(resource)
    ccall((:plutobook_resource_data_destroy, libplutobook), Cvoid, (Ptr{plutobook_resource_data_t},), resource)
end

function plutobook_resource_data_get_reference_count(resource)
    ccall((:plutobook_resource_data_get_reference_count, libplutobook), Cuint, (Ptr{plutobook_resource_data_t},), resource)
end

function plutobook_resource_data_get_content(resource)
    ccall((:plutobook_resource_data_get_content, libplutobook), Ptr{Cchar}, (Ptr{plutobook_resource_data_t},), resource)
end

function plutobook_resource_data_get_content_length(resource)
    ccall((:plutobook_resource_data_get_content_length, libplutobook), Cuint, (Ptr{plutobook_resource_data_t},), resource)
end

function plutobook_resource_data_get_mime_type(resource)
    ccall((:plutobook_resource_data_get_mime_type, libplutobook), Ptr{Cchar}, (Ptr{plutobook_resource_data_t},), resource)
end

function plutobook_resource_data_get_text_encoding(resource)
    ccall((:plutobook_resource_data_get_text_encoding, libplutobook), Ptr{Cchar}, (Ptr{plutobook_resource_data_t},), resource)
end

# typedef plutobook_resource_data_t * ( * plutobook_resource_fetch_callback_t ) ( void * closure , const char * url )
const plutobook_resource_fetch_callback_t = Ptr{Cvoid}

function plutobook_fetch_url(url)
    ccall((:plutobook_fetch_url, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{Cchar},), url)
end

function plutobook_set_ssl_cainfo(path)
    ccall((:plutobook_set_ssl_cainfo, libplutobook), Cvoid, (Ptr{Cchar},), path)
end

function plutobook_set_ssl_capath(path)
    ccall((:plutobook_set_ssl_capath, libplutobook), Cvoid, (Ptr{Cchar},), path)
end

function plutobook_set_ssl_verify_peer(verify)
    ccall((:plutobook_set_ssl_verify_peer, libplutobook), Cvoid, (Bool,), verify)
end

function plutobook_set_ssl_verify_host(verify)
    ccall((:plutobook_set_ssl_verify_host, libplutobook), Cvoid, (Bool,), verify)
end

function plutobook_set_http_follow_redirects(follow)
    ccall((:plutobook_set_http_follow_redirects, libplutobook), Cvoid, (Bool,), follow)
end

function plutobook_set_http_max_redirects(amount)
    ccall((:plutobook_set_http_max_redirects, libplutobook), Cvoid, (Cint,), amount)
end

function plutobook_set_http_timeout(timeout)
    ccall((:plutobook_set_http_timeout, libplutobook), Cvoid, (Cint,), timeout)
end

@cenum _plutobook_media_type::UInt32 begin
    PLUTOBOOK_MEDIA_TYPE_PRINT = 0
    PLUTOBOOK_MEDIA_TYPE_SCREEN = 1
end

const plutobook_media_type_t = _plutobook_media_type

mutable struct _plutobook end

const plutobook_t = _plutobook

function plutobook_create(size, margins, media)
    ccall((:plutobook_create, libplutobook), Ptr{plutobook_t}, (plutobook_page_size_t, plutobook_page_margins_t, plutobook_media_type_t), size, margins, media)
end

function plutobook_destroy(book)
    ccall((:plutobook_destroy, libplutobook), Cvoid, (Ptr{plutobook_t},), book)
end

function plutobook_clear_content(book)
    ccall((:plutobook_clear_content, libplutobook), Cvoid, (Ptr{plutobook_t},), book)
end

function plutobook_set_metadata(book, metadata, value)
    ccall((:plutobook_set_metadata, libplutobook), Cvoid, (Ptr{plutobook_t}, plutobook_pdf_metadata_t, Ptr{Cchar}), book, metadata, value)
end

function plutobook_get_metadata(book, metadata)
    ccall((:plutobook_get_metadata, libplutobook), Ptr{Cchar}, (Ptr{plutobook_t}, plutobook_pdf_metadata_t), book, metadata)
end

function plutobook_get_viewport_width(book)
    ccall((:plutobook_get_viewport_width, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

function plutobook_get_viewport_height(book)
    ccall((:plutobook_get_viewport_height, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

function plutobook_get_document_width(book)
    ccall((:plutobook_get_document_width, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

function plutobook_get_document_height(book)
    ccall((:plutobook_get_document_height, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

function plutobook_get_page_size(book)
    ccall((:plutobook_get_page_size, libplutobook), plutobook_page_size_t, (Ptr{plutobook_t},), book)
end

function plutobook_get_page_margins(book)
    ccall((:plutobook_get_page_margins, libplutobook), plutobook_page_margins_t, (Ptr{plutobook_t},), book)
end

function plutobook_get_media_type(book)
    ccall((:plutobook_get_media_type, libplutobook), plutobook_media_type_t, (Ptr{plutobook_t},), book)
end

function plutobook_get_page_count(book)
    ccall((:plutobook_get_page_count, libplutobook), Cuint, (Ptr{plutobook_t},), book)
end

function plutobook_get_page_size_at(book, index)
    ccall((:plutobook_get_page_size_at, libplutobook), plutobook_page_size_t, (Ptr{plutobook_t}, Cuint), book, index)
end

function plutobook_load_url(book, url, user_style, user_script)
    ccall((:plutobook_load_url, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, url, user_style, user_script)
end

function plutobook_load_data(book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
    ccall((:plutobook_load_data, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
end

function plutobook_load_image(book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
    ccall((:plutobook_load_image, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
end

function plutobook_load_xml(book, data, length, user_style, user_script, base_url)
    ccall((:plutobook_load_xml, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, user_style, user_script, base_url)
end

function plutobook_load_html(book, data, length, user_style, user_script, base_url)
    ccall((:plutobook_load_html, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, user_style, user_script, base_url)
end

function plutobook_render_page(book, canvas, page_index)
    ccall((:plutobook_render_page, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{plutobook_canvas_t}, Cuint), book, canvas, page_index)
end

function plutobook_render_page_cairo(book, context, page_index)
    ccall((:plutobook_render_page_cairo, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{cairo_t}, Cuint), book, context, page_index)
end

function plutobook_render_document(book, canvas)
    ccall((:plutobook_render_document, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{plutobook_canvas_t}), book, canvas)
end

function plutobook_render_document_cairo(book, context)
    ccall((:plutobook_render_document_cairo, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{cairo_t}), book, context)
end

function plutobook_render_document_rect(book, canvas, x, y, width, height)
    ccall((:plutobook_render_document_rect, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat), book, canvas, x, y, width, height)
end

function plutobook_render_document_rect_cairo(book, context, x, y, width, height)
    ccall((:plutobook_render_document_rect_cairo, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{cairo_t}, Cfloat, Cfloat, Cfloat, Cfloat), book, context, x, y, width, height)
end

function plutobook_write_to_pdf(book, filename)
    ccall((:plutobook_write_to_pdf, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}), book, filename)
end

function plutobook_write_to_pdf_range(book, filename, from_page, to_page, page_step)
    ccall((:plutobook_write_to_pdf_range, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cuint, Cuint, Cint), book, filename, from_page, to_page, page_step)
end

function plutobook_write_to_pdf_stream(book, callback, closure)
    ccall((:plutobook_write_to_pdf_stream, libplutobook), Bool, (Ptr{plutobook_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}), book, callback, closure)
end

function plutobook_write_to_pdf_stream_range(book, callback, closure, from_page, to_page, page_step)
    ccall((:plutobook_write_to_pdf_stream_range, libplutobook), Bool, (Ptr{plutobook_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}, Cuint, Cuint, Cint), book, callback, closure, from_page, to_page, page_step)
end

function plutobook_write_to_png(book, filename, width, height)
    ccall((:plutobook_write_to_png, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cint, Cint), book, filename, width, height)
end

function plutobook_write_to_png_stream(book, callback, closure, width, height)
    ccall((:plutobook_write_to_png_stream, libplutobook), Bool, (Ptr{plutobook_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}, Cint, Cint), book, callback, closure, width, height)
end

function plutobook_set_custom_resource_fetcher(book, callback, closure)
    ccall((:plutobook_set_custom_resource_fetcher, libplutobook), Cvoid, (Ptr{plutobook_t}, plutobook_resource_fetch_callback_t, Ptr{Cvoid}), book, callback, closure)
end

function plutobook_get_custom_resource_fetcher_callback(book)
    ccall((:plutobook_get_custom_resource_fetcher_callback, libplutobook), plutobook_resource_fetch_callback_t, (Ptr{plutobook_t},), book)
end

function plutobook_get_custom_resource_fetcher_closure(book)
    ccall((:plutobook_get_custom_resource_fetcher_closure, libplutobook), Ptr{Cvoid}, (Ptr{plutobook_t},), book)
end

function plutobook_get_error_message()
    ccall((:plutobook_get_error_message, libplutobook), Ptr{Cchar}, ())
end

function plutobook_clear_error_message()
    ccall((:plutobook_clear_error_message, libplutobook), Cvoid, ())
end

const PLUTOBOOK_VERSION_MAJOR = 0

const PLUTOBOOK_VERSION_MINOR = 3

const PLUTOBOOK_VERSION_MICRO = 0

PLUTOBOOK_VERSION_ENCODE(major, minor, micro) = major * 10000 + minor * 100 + micro * 1

const PLUTOBOOK_VERSION = PLUTOBOOK_VERSION_ENCODE(PLUTOBOOK_VERSION_MAJOR, PLUTOBOOK_VERSION_MINOR, PLUTOBOOK_VERSION_MICRO)

PLUTOBOOK_VERSION_STRINGIZE(major, minor, micro) = PLUTOBOOK_VERSION_XSTRINGIZE(major, minor, micro)

const PLUTOBOOK_VERSION_STRING = PLUTOBOOK_VERSION_STRINGIZE(PLUTOBOOK_VERSION_MAJOR, PLUTOBOOK_VERSION_MINOR, PLUTOBOOK_VERSION_MICRO)

const PLUTOBOOK_MAX_PAGE_COUNT = Cuint(0xffffffff)

const PLUTOBOOK_MIN_PAGE_COUNT = Cuint(0x00000000)

const PLUTOBOOK_UNITS_PT = Float32(1.0)

const PLUTOBOOK_UNITS_PC = Float32(12.0)

const PLUTOBOOK_UNITS_IN = Float32(72.0)

const PLUTOBOOK_PAGE_WIDTH_NONE = Float32(0.0)

const PLUTOBOOK_PAGE_HEIGHT_NONE = Float32(0.0)

const PLUTOBOOK_PAGE_SIZE_NONE = PLUTOBOOK_PAGE_SIZE_NAMED("NONE")

const PLUTOBOOK_PAGE_WIDTH_A3 = 297PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_A3 = 420PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_A3 = PLUTOBOOK_PAGE_SIZE_NAMED("A3")

const PLUTOBOOK_PAGE_WIDTH_A4 = 210PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_A4 = 297PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_A4 = PLUTOBOOK_PAGE_SIZE_NAMED("A4")

const PLUTOBOOK_PAGE_WIDTH_A5 = 148PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_A5 = 210PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_A5 = PLUTOBOOK_PAGE_SIZE_NAMED("A5")

const PLUTOBOOK_PAGE_WIDTH_B4 = 250PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_B4 = 353PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_B4 = PLUTOBOOK_PAGE_SIZE_NAMED("B4")

const PLUTOBOOK_PAGE_WIDTH_B5 = 176PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_B5 = 250PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_B5 = PLUTOBOOK_PAGE_SIZE_NAMED("B5")

const PLUTOBOOK_PAGE_WIDTH_LETTER = Float32(8.5) * PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_HEIGHT_LETTER = 11PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_SIZE_LETTER = PLUTOBOOK_PAGE_SIZE_NAMED("LETTER")

const PLUTOBOOK_PAGE_WIDTH_LEGAL = Float32(8.5) * PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_HEIGHT_LEGAL = 14PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_SIZE_LEGAL = PLUTOBOOK_PAGE_SIZE_NAMED("LEGAL")

const PLUTOBOOK_PAGE_WIDTH_LEDGER = 11PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_HEIGHT_LEDGER = 17PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_SIZE_LEDGER = PLUTOBOOK_PAGE_SIZE_NAMED("LEDGER")

const PLUTOBOOK_PAGE_MARGINS_NONE = PLUTOBOOK_MAKE_PAGE_MARGINS(0, 0, 0, 0)

const PLUTOBOOK_PAGE_MARGINS_NORMAL = PLUTOBOOK_MAKE_PAGE_MARGINS(72, 72, 72, 72)

const PLUTOBOOK_PAGE_MARGINS_NARROW = PLUTOBOOK_MAKE_PAGE_MARGINS(36, 36, 36, 36)

const PLUTOBOOK_PAGE_MARGINS_MODERATE = PLUTOBOOK_MAKE_PAGE_MARGINS(72, 54, 72, 54)

const PLUTOBOOK_PAGE_MARGINS_WIDE = PLUTOBOOK_MAKE_PAGE_MARGINS(72, 144, 72, 144)

##
                                                                                              

# exports
const PREFIXES = ["PLUTOBOOK_", "plutobook_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
