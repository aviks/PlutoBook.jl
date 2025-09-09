using PlutoBook
using Test

@testset "Basic" begin
    @test PLUTOBOOK_VERSION > 100
    @test plutobook_version() > 100
    @test !isempty(unsafe_string(plutobook_build_info()))
    @test !isempty(unsafe_string(plutobook_version_string()))

end

@testset "Hello" begin
    kHTMLContent = """
        <!DOCTYPE html>
        <html lang=\"la\">
        <head>
        <meta charset=\"UTF-8\">
        <title>Magnum Scopulum Corallinum</title>
        <style>
            body { font-family: \"Segoe UI\", sans-serif; line-height: 1.6; margin: 40px auto; max-width: 800px; color: #222; }
            h1 { font-size: 2.5em; margin-bottom: 20px; }
            img { width: 100%; border-radius: 6px; margin-bottom: 20px; }
            p { font-size: 1.05em; text-align: justify; }
        </style>
        </head>
        <body>
        <h1>Magnum Scopulum Corallinum</h1>
        <img src=\"https://picsum.photos/id/128/800/400\" alt=\"Magnum Scopulum Corallinum\">
        <p>Magnum Scopulum Corallinum est maximum systema scopulorum corallinorum in mundo, quod per plus quam 2,300 chiliometra oram septentrionalem-orientalem Australiae extenditur. Ex milibus scopulorum individualium et centenis insularum constat, e spatio videri potest et inter mirabilia naturalia mundi numeratur.</p>
        <p>Domus est incredibili diversitati vitae marinae, cum plus quam 1,500 speciebus piscium, 400 generibus corallii, et innumerabilibus aliis organismis. Partem vitalem agit in salute oecosystematis marini conservanda et sustentat victum communitatum litoralium per otium et piscationem.</p>
        <p>Quamquam pulchritudinem ac significationem oecologicam praebet, Magnum Scopulum Corallinum minas continenter patitur ex mutatione climatis, pollutione, et nimia piscatione. Eventus albi corallii ex temperaturis marinis crescentibus magnam partem scopuli nuper laeserunt. Conatus conservatorii toto orbe suscipiuntur ad hunc magnificum oecosystema subaquaneum tuendum et restaurandum.</p>
        </body>
        </html>
    """
    book = plutobook_create(PLUTOBOOK_PAGE_SIZE_A4, PLUTOBOOK_PAGE_MARGINS_NARROW, PLUTOBOOK_MEDIA_TYPE_PRINT)
    plutobook_load_html(book, kHTMLContent, -1, "", "", "")
    plutobook_write_to_pdf(book, "hello.pdf")
    plutobook_destroy(book)

    @test isfile("hello.pdf"); rm("hello.pdf"; force=true)
end

@testset "Alice" begin

    # Create a plutobook instance with A4 page size, narrow margins, and print media type
    book = plutobook_create(
        PLUTOBOOK_PAGE_SIZE_A4,
        PLUTOBOOK_PAGE_MARGINS_NARROW,
        PLUTOBOOK_MEDIA_TYPE_PRINT
    )

    # Load the HTML content from file
    plutobook_load_url(book, "Alice.html", "", "")

    # Get page size in points and convert to pixel dimensions
    page_size = plutobook_get_page_size(book)
    page_width = ceil(page_size.width / PLUTOBOOK_UNITS_PX)
    page_height = ceil(page_size.height / PLUTOBOOK_UNITS_PX)
    
    
    # Create a canvas to render pages as images
    canvas = plutobook_image_canvas_create(
        page_width,
        page_height,
        PLUTOBOOK_IMAGE_FORMAT_ARGB32
    )

    # Render the first 4 pages to PNG files
    for page_index in 0:3
        #Clear the canvas to white before rendering each page
        plutobook_canvas_clear_surface(canvas, 1, 1, 1, 1)

        # Render the page onto the canvas
        plutobook_render_page(book, canvas, page_index)

        # Save the canvas to a PNG file
        plutobook_image_canvas_write_to_png(canvas, "page-$(page_index+1).png")
    end

    @test isfile("page-1.png"); rm("page-1.png"; force=true)
    @test isfile("page-2.png"); rm("page-2.png"; force=true)
    @test isfile("page-3.png"); rm("page-3.png"; force=true)
    @test isfile("page-4.png"); rm("page-4.png"; force=true)

    #  Export pages 1 to 4 (inclusive) to PDF with step=1 (every page in order)
    plutobook_write_to_pdf_range(book, "Alice.pdf", 1, 4, 1)

    @test isfile("Alice.pdf"); rm("Alice.pdf"; force=true)

    # Clean up resources
    plutobook_canvas_destroy(canvas);
    plutobook_destroy(book)

end


@testset "Document Render" begin
    # Define a custom page size in pixel units used as the viewport for layout
    page_size = PLUTOBOOK_MAKE_PAGE_SIZE(1800 * PLUTOBOOK_UNITS_PX, 600 * PLUTOBOOK_UNITS_PX)

    # Create a plutobook instance with the custom page size, no page margins, and screen media type
    book = plutobook_create(page_size, PLUTOBOOK_PAGE_MARGINS_NONE, PLUTOBOOK_MEDIA_TYPE_SCREEN)

    # Load the HTML content from file with a custom user style
    plutobook_load_url(book, "Explore Life Through Moments.html", "body { border: 1px solid gray }", "")

    # Compute the full document dimensions after layout
    width = ceil(plutobook_get_document_width(book))
    height = ceil(plutobook_get_document_height(book))

    # Create a canvas large enough to render the entire document at once
    canvas = plutobook_image_canvas_create(width, height, PLUTOBOOK_IMAGE_FORMAT_ARGB32)

    # Render the full document content to the canvas
    plutobook_render_document(book, canvas)

    # Export the rendered canvas to a PNG file
    plutobook_image_canvas_write_to_png(canvas, "Explore.png")

    @test isfile("Explore.png"); rm("Explore.png"; force=true)
    # Clean up resources
    plutobook_canvas_destroy(canvas)
    plutobook_destroy(book)

end