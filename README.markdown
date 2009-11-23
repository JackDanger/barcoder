Barcoder, v 1.0
===============

### Author : Derek Perez

inspired (heavily) by the work of Author: Anuj Luthra. He originally wrote the library barcode_generator (<http://github.com/anujluthra/barcode-generator/>), that this library is based on.
 
This library is designed to support streaming barcode information, from GBarcode, straight to the web browser using data urls (<http://en.wikipedia.org/wiki/Data_URI_scheme>). This is ideal for no-write filesystem scenarios. It also supports persisting the barcodes to disk, but this is an optional function. By default, data urls are used. Barcode generator makes generating/displaying barcodes for certain alphanumeric ids a piece of cake. This way we can generate any barcode type which Gbarcode -> Gnome Barcode project supports.

### FAQ

#### Why did you create this plugin?

barcode_generator is an awesome plugin, however, it does not interact very well with non-write filesystem style servers, ie: Heroku, or EC2. In the cloud, you can't be writing files to the filesystem (usually) directly, so I thought it was necessary to write a plugin that could use data urls (<http://en.wikipedia.org/wiki/Data_URI_scheme>) to stream the barcode to the browser, __with no filesystem writes whatsoever.__

#### Why didn't you just fork his plugin?

Anuj appeared to not want to rely directly on the RMagick gem itself. Instead, he was calling imagemagick's configure command via Kernel#system. There is nothing wrong with this, but I did not want to add back this dependency if he didn't need/want it. Also, I substantially re-wrote how the plugin generates the barcode with gbarcode.

#### Is your API compatible with barcode_generator?

Yes, it should work identically.

### USAGE:
its as simple as saying: 
`<%= to_barcode 'FJJ4JD' %> `

This will generate a barcode for FJJ4JD in BARCODE_39 format with default width
and height and include it in the view.

### Options Options Options:
To customize your barcodes, you can optionally pass following information in your views 

 + encoding_format (Gbarcode constants for eg. Gbarcode::BARCODE_128 etc..)
 + width
 + height
 + scaling_factor
 + xoff
 + yoff
 + margin
 + no_ascii (accepts boolean true or false, prevents the ascii string from printing at the bottom of the barcode)
 + output_type (accepts :disk or :stream. :disk will print the image to disk, and serve it regularly.)
 
in this case your view will look like:

`<%= to_barcode 'ANUJ', :height => 100, :width  => 400, :margin => 100, :xoff => 20, :yoff => 40 %>`


### Installation:
First install these requirements:

 1. gem for gbarcode
 2. install native ImageMagick library (and RMagick)

Next, install Barcoder:

`install from git : git://github.com/perezd/barcoder.git`

### Supported Barcode Formats:
Gbarcode as of now allows us to generate barcodes in following formats:
        BARCODE_EAN
        BARCODE_UPC
        BARCODE_ISBN
        BARCODE_128B
        BARCODE_128C
        BARCODE_128
        BARCODE_128RAW
        BARCODE_39
        BARCODE_I25
        BARCODE_CBR
        BARCODE_MSI
        BARCODE_PLS
        BARCODE_93
        BARCODE_ANY
        BARCODE_NO_CHECKSUM

for more information on Gbarcode visit http://gbarcode.rubyforge.org/rdoc/index.html
Many many thanks to Anuj Luthra for solving the initial hard work!

