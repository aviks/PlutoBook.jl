

# Command line tools

Two command line utilities are included in this package

* `html2pdf`
* `html2png`

The CLI tools can be accessed via the usual BinaryBuilder command-line mechanism:


```
 using PlutoBook_jll
 html2pdf()  do x
    run(`$x Report.html Report.pdf --user-style 'body  {font-family: "Segoe UI", sans-serif;}'`)
 end
 ```

 ## html2pdf

 Convert html files to pdf files 

 #### Arguments

`input` : "Specify the input HTML filename or URL",
`output` : "Specify the output PDF filename",

`--size` : "Specify the page size (eg. A4)",
`--margin` : "Specify the page margin (eg. 72pt)",
`--media` : "Specify the media type (eg. print, screen)",
`--orientation` : "Specify the page orientation (eg. portrait, landscape)",

`--width` : "Specify the page width (eg. 210mm)",
`--height` : "Specify the page height (eg. 297mm)",

`--margin-top` : "Specify the page margin top (eg. 72pt)",
`--margin-right` : "Specify the page margin right (eg. 72pt)",
`--margin-bottom` : "Specify the page margin bottom (eg. 72pt)",
`--margin-left` : "Specify the page margin left (eg. 72pt)",

`--page-start` : "Specify the first page number to print",
`--page-end` : "Specify the last page number to print",
`--page-step` : "Specify the page step value",

`--user-style` : "Specify the user-defined CSS style",
`--user-script` : "Specify the user-defined JavaScript",

`--title` : "Set PDF document title",
`--subject` : "Set PDF document subject",
`--author` : "Set PDF document author",
`--keywords` : "Set PDF document keywords",
`--creator` : "Set PDF document creator",

 ## html2png

 Convert html files to png images

 #### Arguments

`input` : "Specify the input HTML filename or URL"
`output` : "Specify the output PNG filename"

`--viewport-width` : "Specify the viewport width (eg. 1280px)"
`--viewport-height` : "Specify the viewport height (eg. 720px)"

`--width` : "Specify the output image width (eg. 800px)"
`--height` : "Specify the output image height (eg. 600px)"

`--user-style` : "Specify the user-defined CSS style"
`--user-script` : "Specify the user-defined JavaScript"