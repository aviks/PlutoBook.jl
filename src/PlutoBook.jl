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

"""
    _plutobook_page_size

Defines the dimensions of a page in points (1/72 inch).
"""
struct _plutobook_page_size
    width::Cfloat
    height::Cfloat
end

"""
Defines the dimensions of a page in points (1/72 inch).
"""
const plutobook_page_size_t = _plutobook_page_size

"""
    _plutobook_page_margins

Defines the margins of a page in points (1/72 inch).
"""
struct _plutobook_page_margins
    top::Cfloat
    right::Cfloat
    bottom::Cfloat
    left::Cfloat
end

"""
Defines the margins of a page in points (1/72 inch).
"""
const plutobook_page_margins_t = _plutobook_page_margins

"""
    plutobook_version()

Returns the version of the plutobook library encoded in a single integer.

This function retrieves the version of the plutobook library and encodes it into a single integer. The version number is represented in a format suitable for comparison.

# Returns
The version of the plutobook library encoded in a single integer.
"""
function plutobook_version()
    ccall((:plutobook_version, libplutobook), Cint, ())
end

"""
    plutobook_version_string()

Returns the version of the plutobook library as a human-readable string in the format "X.Y.Z".

This function retrieves the version of the plutobook library and returns it as a human-readable string in the format "X.Y.Z", where X represents the major version, Y represents the minor version, and Z represents the patch version.

# Returns
A pointer to a string containing the version of the plutobook library in the format "X.Y.Z".
"""
function plutobook_version_string()
    ccall((:plutobook_version_string, libplutobook), Ptr{Cchar}, ())
end

"""
    plutobook_build_info()

Returns a string containing the build metadata of the plutobook library.

# Returns
A pointer to a string containing the build metadata of the plutobook library.
"""
function plutobook_build_info()
    ccall((:plutobook_build_info, libplutobook), Ptr{Cchar}, ())
end

"""
    _plutobook_stream_status

Defines status codes that indicate the result of a stream operation.
"""
@cenum _plutobook_stream_status::UInt32 begin
    PLUTOBOOK_STREAM_STATUS_SUCCESS = 0
    PLUTOBOOK_STREAM_STATUS_READ_ERROR = 10
    PLUTOBOOK_STREAM_STATUS_WRITE_ERROR = 11
end

"""
Defines status codes that indicate the result of a stream operation.
"""
const plutobook_stream_status_t = _plutobook_stream_status

# typedef plutobook_stream_status_t ( * plutobook_stream_write_callback_t ) ( void * closure , const char * data , unsigned int length )
"""
This type represents a function called when writing data to an output stream.

# Arguments
* `closure`: user-defined closure for the callback.
* `data`: buffer containing the data to write.
* `length`: the number of bytes to write.
# Returns
`PLUTOBOOK_STREAM_STATUS_SUCCESS` on success, or `PLUTOBOOK_STREAM_STATUS_WRITE_ERROR` on failure.
"""
const plutobook_stream_write_callback_t = Ptr{Cvoid}

mutable struct _cairo_surface end

"Cairo Surface"
const cairo_surface_t = _cairo_surface

mutable struct _cairo end

"Cairo"
const cairo_t = _cairo

mutable struct _plutobook_canvas end

"""
Represents a 2D drawing interface for creating and manipulating graphical content.
"""
const plutobook_canvas_t = _plutobook_canvas

"""
    plutobook_canvas_destroy(canvas)

Destroys the canvas and frees its associated resources.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_canvas_destroy(canvas)
    ccall((:plutobook_canvas_destroy, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_flush(canvas)

Flushes any pending drawing operations on the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_canvas_flush(canvas)
    ccall((:plutobook_canvas_flush, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_finish(canvas)

Finishes all drawing operations and performs cleanup on the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_canvas_finish(canvas)
    ccall((:plutobook_canvas_finish, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_translate(canvas, tx, ty)

Translates the canvas by a given offset, moving its origin.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `tx`: The horizontal translation offset.
* `ty`: The vertical translation offset.
"""
function plutobook_canvas_translate(canvas, tx, ty)
    ccall((:plutobook_canvas_translate, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat), canvas, tx, ty)
end

"""
    plutobook_canvas_scale(canvas, sx, sy)

Scales the canvas by the specified factors in the horizontal and vertical directions.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `sx`: The scaling factor in the horizontal direction.
* `sy`: The scaling factor in the vertical direction.
"""
function plutobook_canvas_scale(canvas, sx, sy)
    ccall((:plutobook_canvas_scale, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat), canvas, sx, sy)
end

"""
    plutobook_canvas_rotate(canvas, angle)

Rotates the canvas around the current origin by the specified angle.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `angle`: The rotation angle in radians.
"""
function plutobook_canvas_rotate(canvas, angle)
    ccall((:plutobook_canvas_rotate, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat), canvas, angle)
end

"""
    plutobook_canvas_transform(canvas, a, b, c, d, e, f)

Multiplies the current transformation matrix with the specified matrix.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `a`: The horizontal scaling factor.
* `b`: The horizontal skewing factor.
* `c`: The vertical skewing factor.
* `d`: The vertical scaling factor.
* `e`: The horizontal translation offset.
* `f`: The vertical translation offset.
"""
function plutobook_canvas_transform(canvas, a, b, c, d, e, f)
    ccall((:plutobook_canvas_transform, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), canvas, a, b, c, d, e, f)
end

"""
    plutobook_canvas_set_matrix(canvas, a, b, c, d, e, f)

Resets the transformation matrix to the specified matrix.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `a`: The horizontal scaling factor.
* `b`: The horizontal skewing factor.
* `c`: The vertical skewing factor.
* `d`: The vertical scaling factor.
* `e`: The horizontal translation offset.
* `f`: The vertical translation offset.
"""
function plutobook_canvas_set_matrix(canvas, a, b, c, d, e, f)
    ccall((:plutobook_canvas_set_matrix, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat, Cfloat), canvas, a, b, c, d, e, f)
end

"""
    plutobook_canvas_reset_matrix(canvas)

Resets the current transformation matrix to the identity matrix.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_canvas_reset_matrix(canvas)
    ccall((:plutobook_canvas_reset_matrix, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_clip_rect(canvas, x, y, width, height)

Intersects the current clip region with the specified rectangle.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `x`: The x-coordinate of the rectangle’s top-left corner.
* `y`: The y-coordinate of the rectangle’s top-left corner.
* `width`: The width of the rectangle.
* `height`: The height of the rectangle.
"""
function plutobook_canvas_clip_rect(canvas, x, y, width, height)
    ccall((:plutobook_canvas_clip_rect, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat), canvas, x, y, width, height)
end

"""
    plutobook_canvas_clear_surface(canvas, red, green, blue, alpha)

Clears the canvas surface with the specified color.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `red`: The red component of the color, in the range [0, 1].
* `green`: The green component of the color, in the range [0, 1].
* `blue`: The blue component of the color, in the range [0, 1].
* `alpha`: The alpha (transparency) component of the color, in the range [0, 1].
"""
function plutobook_canvas_clear_surface(canvas, red, green, blue, alpha)
    ccall((:plutobook_canvas_clear_surface, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat), canvas, red, green, blue, alpha)
end

"""
    plutobook_canvas_save_state(canvas)

Saves the current state of the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_canvas_save_state(canvas)
    ccall((:plutobook_canvas_save_state, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_restore_state(canvas)

Restores the most recently saved state of the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_canvas_restore_state(canvas)
    ccall((:plutobook_canvas_restore_state, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_get_surface(canvas)

Gets the underlying cairo surface associated with the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
A pointer to the underlying [`cairo_surface_t`](@ref) object.
"""
function plutobook_canvas_get_surface(canvas)
    ccall((:plutobook_canvas_get_surface, libplutobook), Ptr{cairo_surface_t}, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_canvas_get_context(canvas)

Gets the underlying cairo context associated with the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
A pointer to the underlying [`cairo_t`](@ref) object.
"""
function plutobook_canvas_get_context(canvas)
    ccall((:plutobook_canvas_get_context, libplutobook), Ptr{cairo_t}, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    _plutobook_image_format

Defines different memory formats for image data.
"""
@cenum _plutobook_image_format::Int32 begin
    PLUTOBOOK_IMAGE_FORMAT_INVALID = -1
    PLUTOBOOK_IMAGE_FORMAT_ARGB32 = 0
    PLUTOBOOK_IMAGE_FORMAT_RGB24 = 1
    PLUTOBOOK_IMAGE_FORMAT_A8 = 2
    PLUTOBOOK_IMAGE_FORMAT_A1 = 3
end

"""
Defines different memory formats for image data.
"""
const plutobook_image_format_t = _plutobook_image_format

"""
    plutobook_image_canvas_create(width, height, format)

Creates a new canvas for drawing to image data with the specified dimensions and format.

# Arguments
* `width`: The width of the image in pixels.
* `height`: The height of the image in pixels.
* `format`: The image format used for the canvas.
# Returns
A pointer to a newly created [`plutobook_canvas_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_image_canvas_create(width, height, format)
    ccall((:plutobook_image_canvas_create, libplutobook), Ptr{plutobook_canvas_t}, (Cint, Cint, plutobook_image_format_t), width, height, format)
end

"""
    plutobook_image_canvas_create_for_data(data, width, height, stride, format)

Creates a new canvas for drawing to existing image data.

# Arguments
* `data`: A pointer to the raw image data.
* `width`: The width of the image in pixels.
* `height`: The height of the image in pixels.
* `stride`: The number of bytes in one row of the image, including padding.
* `format`: The image format used for the canvas.
# Returns
A pointer to a newly created [`plutobook_canvas_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_image_canvas_create_for_data(data, width, height, stride, format)
    ccall((:plutobook_image_canvas_create_for_data, libplutobook), Ptr{plutobook_canvas_t}, (Ptr{Cuchar}, Cint, Cint, Cint, plutobook_image_format_t), data, width, height, stride, format)
end

"""
    plutobook_image_canvas_get_data(canvas)

Retrieves the image data from the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
A pointer to the image data.
"""
function plutobook_image_canvas_get_data(canvas)
    ccall((:plutobook_image_canvas_get_data, libplutobook), Ptr{Cuchar}, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_image_canvas_get_format(canvas)

Retrieves the format of the image data on the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
The image format of the canvas.
"""
function plutobook_image_canvas_get_format(canvas)
    ccall((:plutobook_image_canvas_get_format, libplutobook), plutobook_image_format_t, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_image_canvas_get_width(canvas)

Retrieves the width of the image data on the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
The width of the canvas image in pixels.
"""
function plutobook_image_canvas_get_width(canvas)
    ccall((:plutobook_image_canvas_get_width, libplutobook), Cint, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_image_canvas_get_height(canvas)

Retrieves the height of the image data on the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
The height of the canvas image in pixels.
"""
function plutobook_image_canvas_get_height(canvas)
    ccall((:plutobook_image_canvas_get_height, libplutobook), Cint, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_image_canvas_get_stride(canvas)

Retrieves the stride (the number of bytes per row) of the image data on the canvas.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
# Returns
The stride of the canvas image in bytes.
"""
function plutobook_image_canvas_get_stride(canvas)
    ccall((:plutobook_image_canvas_get_stride, libplutobook), Cint, (Ptr{plutobook_canvas_t},), canvas)
end

"""
    plutobook_image_canvas_write_to_png(canvas, filename)

Writes the image data from the canvas to a PNG file.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `filename`: The path to the file where the PNG image will be saved.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_image_canvas_write_to_png(canvas, filename)
    ccall((:plutobook_image_canvas_write_to_png, libplutobook), Bool, (Ptr{plutobook_canvas_t}, Ptr{Cchar}), canvas, filename)
end

"""
    plutobook_image_canvas_write_to_png_stream(canvas, callback, closure)

Writes the image data from the canvas to a PNG stream using a custom write callback.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `callback`: The callback function for writing the image data to a stream.
* `closure`: A user-defined closure passed to the callback.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_image_canvas_write_to_png_stream(canvas, callback, closure)
    ccall((:plutobook_image_canvas_write_to_png_stream, libplutobook), Bool, (Ptr{plutobook_canvas_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}), canvas, callback, closure)
end

"""
    _plutobook_pdf_metadata

Defines different metadata fields for a PDF document.
"""
@cenum _plutobook_pdf_metadata::UInt32 begin
    PLUTOBOOK_PDF_METADATA_TITLE = 0
    PLUTOBOOK_PDF_METADATA_AUTHOR = 1
    PLUTOBOOK_PDF_METADATA_SUBJECT = 2
    PLUTOBOOK_PDF_METADATA_KEYWORDS = 3
    PLUTOBOOK_PDF_METADATA_CREATOR = 4
    PLUTOBOOK_PDF_METADATA_CREATION_DATE = 5
    PLUTOBOOK_PDF_METADATA_MODIFICATION_DATE = 6
end

"""
Defines different metadata fields for a PDF document.
"""
const plutobook_pdf_metadata_t = _plutobook_pdf_metadata

"""
    plutobook_pdf_canvas_create(filename, size)

Creates a new canvas for generating a PDF file.

# Arguments
* `filename`: A path to the output PDF file.
* `size`: The page size for the PDF.
# Returns
A pointer to a newly created [`plutobook_canvas_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_pdf_canvas_create(filename, size)
    ccall((:plutobook_pdf_canvas_create, libplutobook), Ptr{plutobook_canvas_t}, (Ptr{Cchar}, plutobook_page_size_t), filename, size)
end

"""
    plutobook_pdf_canvas_create_for_stream(callback, closure, size)

Creates a new canvas for generating a PDF and writes it to a stream.

# Arguments
* `callback`: A callback function to write the data to a stream.
* `closure`: A user-defined pointer passed to the callback function.
* `size`: The page size for the PDF.
# Returns
A pointer to a newly created [`plutobook_canvas_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_pdf_canvas_create_for_stream(callback, closure, size)
    ccall((:plutobook_pdf_canvas_create_for_stream, libplutobook), Ptr{plutobook_canvas_t}, (plutobook_stream_write_callback_t, Ptr{Cvoid}, plutobook_page_size_t), callback, closure, size)
end

"""
    plutobook_pdf_canvas_set_metadata(canvas, metadata, value)

Sets the metadata of the PDF document.

The `PDF_METADATA_CREATION_DATE` and `PDF_METADATA_MODIFICATION_DATE` values must be in ISO-8601 format: YYYY-MM-DDThh:mm:ss. An optional timezone of the form "[+/-]hh:mm" or "Z" for UTC time can be appended. All other metadata values can be any string.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `metadata`: The metadata type to set.
* `value`: The value of the metadata field.
"""
function plutobook_pdf_canvas_set_metadata(canvas, metadata, value)
    ccall((:plutobook_pdf_canvas_set_metadata, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, plutobook_pdf_metadata_t, Ptr{Cchar}), canvas, metadata, value)
end

"""
    plutobook_pdf_canvas_set_size(canvas, size)

Sets the size of the PDF page.

This function should only be called before any drawing operations are performed on the current page. The simplest way to do this is by calling this function immediately after creating the canvas or  immediately after completing a page with [`plutobook_pdf_canvas_show_page`](@ref).

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
* `size`: The desired size of the PDF page.
"""
function plutobook_pdf_canvas_set_size(canvas, size)
    ccall((:plutobook_pdf_canvas_set_size, libplutobook), Cvoid, (Ptr{plutobook_canvas_t}, plutobook_page_size_t), canvas, size)
end

"""
    plutobook_pdf_canvas_show_page(canvas)

Finalizes the current page and prepares the canvas for a new page.

# Arguments
* `canvas`: A pointer to a [`plutobook_canvas_t`](@ref) object.
"""
function plutobook_pdf_canvas_show_page(canvas)
    ccall((:plutobook_pdf_canvas_show_page, libplutobook), Cvoid, (Ptr{plutobook_canvas_t},), canvas)
end

# typedef void ( * plutobook_resource_destroy_callback_t ) ( void * data )
"""
A callback function type for resource data destruction.

# Arguments
* `data`: A pointer to the resource data to be destroyed.
"""
const plutobook_resource_destroy_callback_t = Ptr{Cvoid}

mutable struct _plutobook_resource_data end

"""
A structure representing the resource data.
"""
const plutobook_resource_data_t = _plutobook_resource_data

"""
    plutobook_resource_data_create(content, content_length, mime_type, text_encoding)

Creates a new [`plutobook_resource_data_t`](@ref) object by copying the provided content.

# Arguments
* `content`: The content of the resource.
* `content_length`: The length of the content in bytes.
* `mime_type`: The MIME type of the content.
* `text_encoding`: The text encoding used for the content.
# Returns
A pointer to a newly created [`plutobook_resource_data_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_resource_data_create(content, content_length, mime_type, text_encoding)
    ccall((:plutobook_resource_data_create, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}), content, content_length, mime_type, text_encoding)
end

"""
    plutobook_resource_data_create_without_copy(content, content_length, mime_type, text_encoding, destroy_callback, closure)

Creates a new [`plutobook_resource_data_t`](@ref) object using the provided content "as is", and uses the `destroy_callback` to free the resource when it's no longer needed.

# Arguments
* `content`: The content of the resource.
* `content_length`: The length of the content in bytes.
* `mime_type`: The MIME type of the content.
* `text_encoding`: The text encoding used for the content.
* `destroy_callback`: A callback function that will be called to free the resource when it's no longer needed.
* `closure`: A user-defined pointer that will be passed to the `destroy_callback` when called.
# Returns
A pointer to a newly created [`plutobook_resource_data_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_resource_data_create_without_copy(content, content_length, mime_type, text_encoding, destroy_callback, closure)
    ccall((:plutobook_resource_data_create_without_copy, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}, plutobook_resource_destroy_callback_t, Ptr{Cvoid}), content, content_length, mime_type, text_encoding, destroy_callback, closure)
end

"""
    plutobook_resource_data_reference(resource)

Increases the reference count of a resource data object.

This function returns a reference to the given [`plutobook_resource_data_t`](@ref) object, incrementing its reference count. This is useful for managing the lifetime of resource data objects in a reference-counted system.

# Arguments
* `resource`: A pointer to the [`plutobook_resource_data_t`](@ref) object to reference.
# Returns
A pointer to the referenced [`plutobook_resource_data_t`](@ref) object.
"""
function plutobook_resource_data_reference(resource)
    ccall((:plutobook_resource_data_reference, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{plutobook_resource_data_t},), resource)
end

"""
    plutobook_resource_data_destroy(resource)

Destroys a resource data object and frees its associated memory.

This function decreases the reference count of the [`plutobook_resource_data_t`](@ref) object, and if the reference count drops to zero, the resource is destroyed and its memory is freed.

# Arguments
* `resource`: A pointer to the [`plutobook_resource_data_t`](@ref) object to destroy.
"""
function plutobook_resource_data_destroy(resource)
    ccall((:plutobook_resource_data_destroy, libplutobook), Cvoid, (Ptr{plutobook_resource_data_t},), resource)
end

"""
    plutobook_resource_data_get_reference_count(resource)

Gets the current reference count of a resource data object.

This function returns the number of references to the [`plutobook_resource_data_t`](@ref) object, helping manage the object's lifetime and determine if it can be safely destroyed.

# Arguments
* `resource`: A pointer to the [`plutobook_resource_data_t`](@ref) object.
# Returns
The current reference count of the [`plutobook_resource_data_t`](@ref) object.
"""
function plutobook_resource_data_get_reference_count(resource)
    ccall((:plutobook_resource_data_get_reference_count, libplutobook), Cuint, (Ptr{plutobook_resource_data_t},), resource)
end

"""
    plutobook_resource_data_get_content(resource)

Retrieves the content of the resource.

# Arguments
* `resource`: A pointer to a [`plutobook_resource_data_t`](@ref) object.
# Returns
The content of the resource.
"""
function plutobook_resource_data_get_content(resource)
    ccall((:plutobook_resource_data_get_content, libplutobook), Ptr{Cchar}, (Ptr{plutobook_resource_data_t},), resource)
end

"""
    plutobook_resource_data_get_content_length(resource)

Retrieves the length of the resource content.

# Arguments
* `resource`: A pointer to a [`plutobook_resource_data_t`](@ref) object.
# Returns
The length of the resource content in bytes.
"""
function plutobook_resource_data_get_content_length(resource)
    ccall((:plutobook_resource_data_get_content_length, libplutobook), Cuint, (Ptr{plutobook_resource_data_t},), resource)
end

"""
    plutobook_resource_data_get_mime_type(resource)

Retrieves the MIME type of the resource content.

# Arguments
* `resource`: A pointer to a [`plutobook_resource_data_t`](@ref) object.
# Returns
The MIME type of the resource content.
"""
function plutobook_resource_data_get_mime_type(resource)
    ccall((:plutobook_resource_data_get_mime_type, libplutobook), Ptr{Cchar}, (Ptr{plutobook_resource_data_t},), resource)
end

"""
    plutobook_resource_data_get_text_encoding(resource)

Retrieves the text encoding used for the resource content.

# Arguments
* `resource`: A pointer to a [`plutobook_resource_data_t`](@ref) object.
# Returns
The text encoding used for the resource content.
"""
function plutobook_resource_data_get_text_encoding(resource)
    ccall((:plutobook_resource_data_get_text_encoding, libplutobook), Ptr{Cchar}, (Ptr{plutobook_resource_data_t},), resource)
end

# typedef plutobook_resource_data_t * ( * plutobook_resource_fetch_callback_t ) ( void * closure , const char * url )
"""
Defines a callback type for fetching resource data from a URL.

The callback should return a pointer to a [`plutobook_resource_data_t`](@ref) object, which contains the content fetched from the given URL.

# Arguments
* `closure`: A user-defined pointer that will be passed to the callback (can be used for custom state or data).
* `url`: The URL of the resource to fetch.
# Returns
A pointer to a [`plutobook_resource_data_t`](@ref) object containing the fetched resource, or `NULL` if an error occurs.
"""
const plutobook_resource_fetch_callback_t = Ptr{Cvoid}

"""
    plutobook_fetch_url(url)

Fetches resource data from a given URL using the default resource fetcher.

This function uses a predefined mechanism to fetch resource data from the specified URL and return it as a [`plutobook_resource_data_t`](@ref) object.

# Arguments
* `url`: The URL of the resource to fetch.
# Returns
A pointer to a [`plutobook_resource_data_t`](@ref) object containing the fetched content, or `NULL` if the fetch operation fails.
"""
function plutobook_fetch_url(url)
    ccall((:plutobook_fetch_url, libplutobook), Ptr{plutobook_resource_data_t}, (Ptr{Cchar},), url)
end

"""
    plutobook_set_ssl_cainfo(path)

Sets the path to a file containing trusted CA certificates.

If not set, no custom CA file is used.

# Arguments
* `path`: Path to the CA certificate bundle file.
"""
function plutobook_set_ssl_cainfo(path)
    ccall((:plutobook_set_ssl_cainfo, libplutobook), Cvoid, (Ptr{Cchar},), path)
end

"""
    plutobook_set_ssl_capath(path)

Sets the path to a directory containing trusted CA certificates.

If not set, no custom CA path is used.

# Arguments
* `path`: Path to the directory with CA certificates.
"""
function plutobook_set_ssl_capath(path)
    ccall((:plutobook_set_ssl_capath, libplutobook), Cvoid, (Ptr{Cchar},), path)
end

"""
    plutobook_set_ssl_verify_peer(verify)

Enables or disables SSL peer certificate verification.

If not set, verification is enabled by default.

# Arguments
* `verify`: Set to true to verify the peer, false to disable verification.
"""
function plutobook_set_ssl_verify_peer(verify)
    ccall((:plutobook_set_ssl_verify_peer, libplutobook), Cvoid, (Bool,), verify)
end

"""
    plutobook_set_ssl_verify_host(verify)

Enables or disables SSL host name verification.

If not set, verification is enabled by default.

# Arguments
* `verify`: Set to true to verify the host, false to disable verification.
"""
function plutobook_set_ssl_verify_host(verify)
    ccall((:plutobook_set_ssl_verify_host, libplutobook), Cvoid, (Bool,), verify)
end

"""
    plutobook_set_http_follow_redirects(follow)

Enables or disables automatic following of HTTP redirects.

If not set, following redirects is enabled by default.

# Arguments
* `follow`: Set to true to follow redirects, false to disable.
"""
function plutobook_set_http_follow_redirects(follow)
    ccall((:plutobook_set_http_follow_redirects, libplutobook), Cvoid, (Bool,), follow)
end

"""
    plutobook_set_http_max_redirects(amount)

Sets the maximum number of redirects to follow.

If not set, the default maximum is 30.

# Arguments
* `amount`: The maximum number of redirects.
"""
function plutobook_set_http_max_redirects(amount)
    ccall((:plutobook_set_http_max_redirects, libplutobook), Cvoid, (Cint,), amount)
end

"""
    plutobook_set_http_timeout(timeout)

Sets the maximum time allowed for an HTTP request.

If not set, the default timeout is 300 seconds.

# Arguments
* `timeout`: Timeout duration in seconds.
"""
function plutobook_set_http_timeout(timeout)
    ccall((:plutobook_set_http_timeout, libplutobook), Cvoid, (Cint,), timeout)
end

"""
    _plutobook_media_type

Defines the different media types used for CSS  queries.
"""
@cenum _plutobook_media_type::UInt32 begin
    PLUTOBOOK_MEDIA_TYPE_PRINT = 0
    PLUTOBOOK_MEDIA_TYPE_SCREEN = 1
end

"""
Defines the different media types used for CSS  queries.
"""
const plutobook_media_type_t = _plutobook_media_type

mutable struct _plutobook end

"""
Represents a plutobook document.
"""
const plutobook_t = _plutobook

"""
    plutobook_create(size, margins, media)

Creates a new [`plutobook_t`](@ref) object with the specified page size, margins, and media type.

# Arguments
* `size`: The initial page size.
* `margins`: The initial page margins.
* `media`: The media type used for media queries.
# Returns
A pointer to the newly created [`plutobook_t`](@ref) object, or `NULL` on failure.
"""
function plutobook_create(size, margins, media)
    ccall((:plutobook_create, libplutobook), Ptr{plutobook_t}, (plutobook_page_size_t, plutobook_page_margins_t, plutobook_media_type_t), size, margins, media)
end

"""
    plutobook_destroy(book)

Destroys a [`plutobook_t`](@ref) object and frees all associated resources.

# Arguments
* `book`: A pointer to the [`plutobook_t`](@ref) object to destroy.
"""
function plutobook_destroy(book)
    ccall((:plutobook_destroy, libplutobook), Cvoid, (Ptr{plutobook_t},), book)
end

"""
    plutobook_clear_content(book)

Clears the content of the document.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
"""
function plutobook_clear_content(book)
    ccall((:plutobook_clear_content, libplutobook), Cvoid, (Ptr{plutobook_t},), book)
end

"""
    plutobook_set_metadata(book, metadata, value)

Sets the metadata of the PDF document.

The `PDF_METADATA_CREATION_DATE` and `PDF_METADATA_MODIFICATION_DATE` values must be in ISO-8601 format: YYYY-MM-DDThh:mm:ss. An optional timezone of the form "[+/-]hh:mm" or "Z" for UTC time can be appended. All other metadata values can be any string.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `metadata`: The metadata type to set.
* `value`: The value of the metadata field.
"""
function plutobook_set_metadata(book, metadata, value)
    ccall((:plutobook_set_metadata, libplutobook), Cvoid, (Ptr{plutobook_t}, plutobook_pdf_metadata_t, Ptr{Cchar}), book, metadata, value)
end

"""
    plutobook_get_metadata(book, metadata)

Gets the value of the specified metadata.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `metadata`: The type of metadata to get.
# Returns
The value of the specified metadata.
"""
function plutobook_get_metadata(book, metadata)
    ccall((:plutobook_get_metadata, libplutobook), Ptr{Cchar}, (Ptr{plutobook_t}, plutobook_pdf_metadata_t), book, metadata)
end

"""
    plutobook_get_viewport_width(book)

Returns the width of the viewport.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The width of the viewport in pixels.
"""
function plutobook_get_viewport_width(book)
    ccall((:plutobook_get_viewport_width, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_viewport_height(book)

Returns the height of the viewport.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The height of the viewport in pixels.
"""
function plutobook_get_viewport_height(book)
    ccall((:plutobook_get_viewport_height, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_document_width(book)

Returns the width of the document.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The width of the document in pixels.
"""
function plutobook_get_document_width(book)
    ccall((:plutobook_get_document_width, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_document_height(book)

Returns the height of the document.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The height of the document in pixels.
"""
function plutobook_get_document_height(book)
    ccall((:plutobook_get_document_height, libplutobook), Cfloat, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_page_size(book)

Returns the initial page size.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The initial page size.
"""
function plutobook_get_page_size(book)
    ccall((:plutobook_get_page_size, libplutobook), plutobook_page_size_t, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_page_margins(book)

Returns the initial page margins.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The initial page margins.
"""
function plutobook_get_page_margins(book)
    ccall((:plutobook_get_page_margins, libplutobook), plutobook_page_margins_t, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_media_type(book)

Returns the media type used for media queries.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The media type used for media queries.
"""
function plutobook_get_media_type(book)
    ccall((:plutobook_get_media_type, libplutobook), plutobook_media_type_t, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_page_count(book)

Returns the number of pages in the document.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
The number of pages in the document.
"""
function plutobook_get_page_count(book)
    ccall((:plutobook_get_page_count, libplutobook), Cuint, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_page_size_at(book, index)

Returns the page size at the specified index.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `index`: The index of the page.
# Returns
The size of the page at the specified index.
"""
function plutobook_get_page_size_at(book, index)
    ccall((:plutobook_get_page_size_at, libplutobook), plutobook_page_size_t, (Ptr{plutobook_t}, Cuint), book, index)
end

"""
    plutobook_load_url(book, url, user_style, user_script)

Loads the document from the specified URL.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `url`: The URL to load the document from.
* `user_style`: An optional user-defined style to apply.
* `user_script`: An optional user-defined script to run after the document has loaded.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_load_url(book, url, user_style, user_script)
    ccall((:plutobook_load_url, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, url, user_style, user_script)
end

"""
    plutobook_load_data(book, data, length, mime_type, text_encoding, user_style, user_script, base_url)

Loads the document from the specified data.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `data`: The data to load the document from.
* `length`: The length of the data in bytes.
* `mime_type`: The MIME type of the data.
* `text_encoding`: The text encoding of the data.
* `user_style`: An optional user-defined style to apply.
* `user_script`: An optional user-defined script to run after the document has loaded.
* `base_url`: The base URL for resolving relative URLs.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_load_data(book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
    ccall((:plutobook_load_data, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
end

"""
    plutobook_load_image(book, data, length, mime_type, text_encoding, user_style, user_script, base_url)

Loads the document from the specified image data.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `data`: The image data to load the document from.
* `length`: The length of the image data in bytes.
* `mime_type`: The MIME type of the image data.
* `text_encoding`: The text encoding of the image data.
* `user_style`: An optional user-defined style to apply.
* `user_script`: An optional user-defined script to run after the document has loaded.
* `base_url`: The base URL for resolving relative URLs.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_load_image(book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
    ccall((:plutobook_load_image, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cuint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, mime_type, text_encoding, user_style, user_script, base_url)
end

"""
    plutobook_load_xml(book, data, length, user_style, user_script, base_url)

Loads the document from the specified XML data.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `data`: The XML data to load the document from, encoded in UTF-8.
* `length`: The length of the XML data in bytes, or `-1` if null-terminated.
* `user_style`: An optional user-defined style to apply.
* `user_script`: An optional user-defined script to run after the document has loaded.
* `base_url`: The base URL for resolving relative URLs.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_load_xml(book, data, length, user_style, user_script, base_url)
    ccall((:plutobook_load_xml, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, user_style, user_script, base_url)
end

"""
    plutobook_load_html(book, data, length, user_style, user_script, base_url)

Loads the document from the specified HTML data.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `data`: The HTML data to load the document from, encoded in UTF-8.
* `length`: The length of the HTML data in bytes, or `-1` if null-terminated.
* `user_style`: An optional user-defined style to apply.
* `user_script`: An optional user-defined script to run after the document has loaded.
* `base_url`: The base URL for resolving relative URLs.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_load_html(book, data, length, user_style, user_script, base_url)
    ccall((:plutobook_load_html, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cint, Ptr{Cchar}, Ptr{Cchar}, Ptr{Cchar}), book, data, length, user_style, user_script, base_url)
end

"""
    plutobook_render_page(book, canvas, page_index)

Renders the specified page to the given canvas.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `canvas`: The canvas to render the page on.
* `page_index`: The index of the page to render.
"""
function plutobook_render_page(book, canvas, page_index)
    ccall((:plutobook_render_page, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{plutobook_canvas_t}, Cuint), book, canvas, page_index)
end

"""
    plutobook_render_page_cairo(book, context, page_index)

Renders the specified page to the given cairo context.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `context`: The cairo context to render the page on.
* `page_index`: The index of the page to render.
"""
function plutobook_render_page_cairo(book, context, page_index)
    ccall((:plutobook_render_page_cairo, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{cairo_t}, Cuint), book, context, page_index)
end

"""
    plutobook_render_document(book, canvas)

Renders the entire document to the given canvas.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `canvas`: The canvas to render the entire document on.
"""
function plutobook_render_document(book, canvas)
    ccall((:plutobook_render_document, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{plutobook_canvas_t}), book, canvas)
end

"""
    plutobook_render_document_cairo(book, context)

Renders the entire document to the given cairo context.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `canvas`: The cairo context to render the entire document on.
"""
function plutobook_render_document_cairo(book, context)
    ccall((:plutobook_render_document_cairo, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{cairo_t}), book, context)
end

"""
    plutobook_render_document_rect(book, canvas, x, y, width, height)

Renders a specific rectangular portion of the document to the given canvas.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `canvas`: The canvas to render the document portion on.
* `x`: The x-coordinate of the top-left corner of the rectangle.
* `y`: The y-coordinate of the top-left corner of the rectangle.
* `width`: The width of the rectangle to render.
* `height`: The height of the rectangle to render.
"""
function plutobook_render_document_rect(book, canvas, x, y, width, height)
    ccall((:plutobook_render_document_rect, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{plutobook_canvas_t}, Cfloat, Cfloat, Cfloat, Cfloat), book, canvas, x, y, width, height)
end

"""
    plutobook_render_document_rect_cairo(book, context, x, y, width, height)

Renders a specific rectangular portion of the document to the given cairo context.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `canvas`: The cairo context to render the document portion on.
* `x`: The x-coordinate of the top-left corner of the rectangle.
* `y`: The y-coordinate of the top-left corner of the rectangle.
* `width`: The width of the rectangle to render.
* `height`: The height of the rectangle to render.
"""
function plutobook_render_document_rect_cairo(book, context, x, y, width, height)
    ccall((:plutobook_render_document_rect_cairo, libplutobook), Cvoid, (Ptr{plutobook_t}, Ptr{cairo_t}, Cfloat, Cfloat, Cfloat, Cfloat), book, context, x, y, width, height)
end

"""
    plutobook_write_to_pdf(book, filename)

Writes the entire document to a PDF file.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `filename`: The name of the PDF file to write the document to.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_write_to_pdf(book, filename)
    ccall((:plutobook_write_to_pdf, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}), book, filename)
end

"""
    plutobook_write_to_pdf_range(book, filename, from_page, to_page, page_step)

Writes a range of pages from the document to a PDF file.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `filename`: The name of the PDF file to write the document to.
* `from_page`: The starting page number for the range to be written.
* `to_page`: The ending page number for the range to be written.
* `page_step`: The step value for iterating through the pages in the range.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_write_to_pdf_range(book, filename, from_page, to_page, page_step)
    ccall((:plutobook_write_to_pdf_range, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cuint, Cuint, Cint), book, filename, from_page, to_page, page_step)
end

"""
    plutobook_write_to_pdf_stream(book, callback, closure)

Writes the entire document to a PDF stream using a callback function.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `callback`: A callback function used for writing the PDF stream.
* `closure`: A user-defined pointer passed to the callback function for additional data.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_write_to_pdf_stream(book, callback, closure)
    ccall((:plutobook_write_to_pdf_stream, libplutobook), Bool, (Ptr{plutobook_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}), book, callback, closure)
end

"""
    plutobook_write_to_pdf_stream_range(book, callback, closure, from_page, to_page, page_step)

Writes a specified range of pages from the document to a PDF stream using a callback function.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `callback`: A callback function used for writing the PDF stream.
* `closure`: A user-defined pointer passed to the callback function for additional data.
* `from_page`: The starting page number for the range to be written.
* `to_page`: The ending page number for the range to be written.
* `page_step`: The step value for iterating through the pages in the range.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_write_to_pdf_stream_range(book, callback, closure, from_page, to_page, page_step)
    ccall((:plutobook_write_to_pdf_stream_range, libplutobook), Bool, (Ptr{plutobook_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}, Cuint, Cuint, Cint), book, callback, closure, from_page, to_page, page_step)
end

"""
    plutobook_write_to_png(book, filename, width, height)

Writes the entire document to a PNG image file.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `filename`: The file path where the PNG image will be written.
* `width`: The desired width in pixels, or -1 to auto-scale based on the document size.
* `height`: The desired height in pixels, or -1 to auto-scale based on the document size.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_write_to_png(book, filename, width, height)
    ccall((:plutobook_write_to_png, libplutobook), Bool, (Ptr{plutobook_t}, Ptr{Cchar}, Cint, Cint), book, filename, width, height)
end

"""
    plutobook_write_to_png_stream(book, callback, closure, width, height)

Writes the entire document to a PNG image stream using a callback function.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `callback`: A callback function to handle the image data stream.
* `closure`: A pointer to user-defined data to pass to the callback function.
* `width`: The desired width in pixels, or -1 to auto-scale based on the document size.
* `height`: The desired height in pixels, or -1 to auto-scale based on the document size.
# Returns
`true` on success, or `false` on failure.
"""
function plutobook_write_to_png_stream(book, callback, closure, width, height)
    ccall((:plutobook_write_to_png_stream, libplutobook), Bool, (Ptr{plutobook_t}, plutobook_stream_write_callback_t, Ptr{Cvoid}, Cint, Cint), book, callback, closure, width, height)
end

"""
    plutobook_set_custom_resource_fetcher(book, callback, closure)

Sets a custom resource fetcher callback for the document.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
* `callback`: A function pointer to the custom resource fetch callback.
* `closure`: A pointer to user-defined data to pass to the callback function.
"""
function plutobook_set_custom_resource_fetcher(book, callback, closure)
    ccall((:plutobook_set_custom_resource_fetcher, libplutobook), Cvoid, (Ptr{plutobook_t}, plutobook_resource_fetch_callback_t, Ptr{Cvoid}), book, callback, closure)
end

"""
    plutobook_get_custom_resource_fetcher_callback(book)

Gets the custom resource fetcher callback set for the document.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
A function pointer to the custom resource fetch callback, or `NULL` if no callback is set.
"""
function plutobook_get_custom_resource_fetcher_callback(book)
    ccall((:plutobook_get_custom_resource_fetcher_callback, libplutobook), plutobook_resource_fetch_callback_t, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_custom_resource_fetcher_closure(book)

Gets the user-defined closure data passed to the custom resource fetcher callback.

# Arguments
* `book`: A pointer to a [`plutobook_t`](@ref) object.
# Returns
A pointer to the closure data, or `NULL` if no closure is set.
"""
function plutobook_get_custom_resource_fetcher_closure(book)
    ccall((:plutobook_get_custom_resource_fetcher_closure, libplutobook), Ptr{Cvoid}, (Ptr{plutobook_t},), book)
end

"""
    plutobook_get_error_message()

Retrieves the last error message that occurred on the current thread.

This function returns a message describing the most recent error that occurred in the current thread as set by `[`plutobook_set_error_message`](@ref)()`. If multiple errors occur before this function is called, only the most recent message is returned.

!!! note

    This function does not indicate whether an error has occurred. You must check the return values of PlutoBook API functions to determine if an operation failed. Do not rely solely on `[`plutobook_get_error_message`](@ref)()` to detect errors.

!!! note

    PlutoBook does not clear the error message on successful API calls. It is your responsibility to check return values and determine when to clear or ignore the message.

!!! note

    Error messages are stored in thread-local storage. An error message set in one thread will not interfere with messages or behavior in another thread.

# Returns
A pointer to the current error message string.
"""
function plutobook_get_error_message()
    ccall((:plutobook_get_error_message, libplutobook), Ptr{Cchar}, ())
end

"""
    plutobook_clear_error_message()



Clears any previously set error message for the current thread.
"""
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

const PLUTOBOOK_PAGE_SIZE_NONE =PLUTOBOOK_PAGE_SIZE_NAMED("NONE")

const PLUTOBOOK_PAGE_WIDTH_A3 = 297PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_A3 = 420PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_A3 =PLUTOBOOK_PAGE_SIZE_NAMED("A3")

const PLUTOBOOK_PAGE_WIDTH_A4 = 210PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_A4 = 297PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_A4 =PLUTOBOOK_PAGE_SIZE_NAMED("A4")

const PLUTOBOOK_PAGE_WIDTH_A5 = 148PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_A5 = 210PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_A5 =PLUTOBOOK_PAGE_SIZE_NAMED("A5")

const PLUTOBOOK_PAGE_WIDTH_B4 = 250PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_B4 = 353PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_B4 =PLUTOBOOK_PAGE_SIZE_NAMED("B4")

const PLUTOBOOK_PAGE_WIDTH_B5 = 176PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_HEIGHT_B5 = 250PLUTOBOOK_UNITS_MM

const PLUTOBOOK_PAGE_SIZE_B5 =PLUTOBOOK_PAGE_SIZE_NAMED("B5")

const PLUTOBOOK_PAGE_WIDTH_LETTER = Float32(8.5) * PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_HEIGHT_LETTER = 11PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_SIZE_LETTER =PLUTOBOOK_PAGE_SIZE_NAMED("LETTER")

const PLUTOBOOK_PAGE_WIDTH_LEGAL = Float32(8.5) * PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_HEIGHT_LEGAL = 14PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_SIZE_LEGAL =PLUTOBOOK_PAGE_SIZE_NAMED("LEGAL")

const PLUTOBOOK_PAGE_WIDTH_LEDGER = 11PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_HEIGHT_LEDGER = 17PLUTOBOOK_UNITS_IN

const PLUTOBOOK_PAGE_SIZE_LEDGER =PLUTOBOOK_PAGE_SIZE_NAMED("LEDGER")

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
