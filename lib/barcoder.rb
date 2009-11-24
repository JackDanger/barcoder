# Barcoder, v.1.0
# written by: Derek Perez (derek@derekperez.com) 2009
# inspired (heavily) by the work of Author: Anuj Luthra. He originally wrote the library
# barcode_generator (http://github.com/anujluthra/barcode-generator/), that this library is
# based on.
# 
# This library is designed to support streaming barcode information, from GBarcode, 
# straight to the web browser using data urls (http://en.wikipedia.org/wiki/Data_URI_scheme).
# This is ideal for no-write filesystem scenarios. It also supports persisting the barcodes 
# to disk, but this is an optional function. By default, data urls are used.
module ActionView
  class Base
    
    # important defaults, should not be messed with.
    VALID_BARCODER_OPTIONS = [:encoding_format, :output_format, :width, :height, :scaling_factor, :xoff, :yoff, :margin, :output_type]
    DEFAULT_BARCODER_OUTPUT_FORMAT = 'gif'
    DEFAULT_BARCODER_ENCODING = Gbarcode::BARCODE_39 | Gbarcode::BARCODE_NO_CHECKSUM
    BARCODE_STORAGE_PATH = "public/images/barcodes"
    
    
    def to_barcode(str, options = {:encoding_format => DEFAULT_BARCODER_ENCODING })
      # verify requirements
      options.assert_valid_keys(VALID_BARCODER_OPTIONS)
      output_format = options[:output_format] ? options[:output_format] : DEFAULT_BARCODER_OUTPUT_FORMAT
      output_type = options[:output_type] ? options[:output_type] : :stream
      # generate the barcode object with all supplied options
      options[:encoding_format] = DEFAULT_BARCODER_ENCODING unless options[:encoding_format]
      bc = Gbarcode.barcode_create(str.to_s)
      
      bc.width  = options[:width]          if options[:width]
      bc.height = options[:height]         if options[:height]
      bc.scalef = options[:scaling_factor] if options[:scaling_factor]
      bc.xoff   = options[:xoff]           if options[:xoff]
      bc.yoff   = options[:yoff]           if options[:yoff]
      bc.margin = options[:margin]         if options[:margin]
      
      Gbarcode.barcode_encode(bc, options[:encoding_format])
      
      if options[:no_ascii]
        print_options = Gbarcode::BARCODE_OUT_EPS|Gbarcode::BARCODE_NO_ASCII
      else
        print_options = Gbarcode::BARCODE_OUT_EPS
      end
      
      # this is where the magic happens.
      data = `echo "#{get_bytes_from_barcode(bc, print_options)}" | convert eps: #{output_format}:`
      
      # simple output strategy, define :output_type => :disk in the #to_barcode call if you want
      # it to write out to the disk for you, otherwise it will be a data url stream.
      output_type == :disk ? barcode_to_disk(data, bc, output_format) : barcode_to_stream(data, output_format, str)
    end
    
    # support for the original barcode-generator plugin syntax.
    def barcode(str, options = {:encoding_format => DEFAULT_BARCODER_ENCODING })
      to_barcode(str, options)
    end
    
    protected 
    
    # stream the barcode to disk. this may be necessary for some cases, but if you
    # are living on a cluster node like say, heroku, this won't work out well for you.
    def barcode_to_disk(data, barcode, output_format)
      filename = "#{barcode.ascii.gsub(" ", "-")}.#{output_format}"
      Dir.mkdir(BARCODE_STORAGE_PATH) unless File.directory?(BARCODE_STORAGE_PATH)
      File.open("#{BARCODE_STORAGE_PATH}/#{filename}", 'w') do |f|
        f.write(data)
      end
      image_tag("barcodes/#{filename}")
    end
    
    # stream the barcode to the client as a data url. often times, the barcode
    # filesize is so minute, that this is absolutely acceptable. NOTE: I intentionally
    # draw my own img tag for this, image_tag doesn't really like this.
    def barcode_to_stream(data, format, str)
      src = "data:image/#{format};base64,#{Base64.encode64(data)}"
      %Q{<img src="#{src}" alt="#{str}" />}
    end
    
    # this method tricks GBarcode into printing the contents of the EPS into
    # a file pipe, allowing us to get at the binary data, without touching the disk.
    def get_bytes_from_barcode(barcode, print_options)
      read, write = IO.pipe
      Gbarcode.barcode_print(barcode, write, print_options)
      write.close
      buffer = read.readlines.join("\n")
      read.close
      return buffer
    end
    
  end
end