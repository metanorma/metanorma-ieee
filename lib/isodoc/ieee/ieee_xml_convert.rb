require "isodoc"
require "mnconvert"

module IsoDoc
  module Ieee
    class IeeeXMLConvert < IsoDoc::XslfoPdfConvert
      def initialize(options) # rubocop:disable Lint/MissingSuper
        @libdir = File.dirname(__FILE__)
        @format = :ieee
        @suffix = "ieee.xml"
        @ieeedtd = options[:ieeedtd]
      end

      def inputfile(in_fname, filename)
        /\.xml$/.match?(in_fname) or
          in_fname = Tempfile.open([filename, ".xml"], encoding: "utf-8") do |f|
            f.write file
            f.path
          end
        in_fname
      end

      def convert(in_fname, file = nil, debug = false, out_fname = nil)
        file = File.read(in_fname, encoding: "utf-8") if file.nil?
        _docxml, filename, dir = convert_init(file, in_fname, debug)
        in_fname = inputfile(in_fname, filename)
        FileUtils.rm_rf dir
        opt = { input_format: MnConvert::InputFormat::MN,
                output_file: out_fname || "#{filename}.#{@suffix}",
                output_format: :ieee }
        @ieeedtd and opt.merge!(validation_against: @ieeedtd)
        MnConvert.convert(in_fname, opt)
      end
    end
  end
end
