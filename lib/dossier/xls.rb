module Dossier
  class Xls


    def initialize(opts = {})
      @headers    = opts[:headers] || opts[:collection].shift
      @collection = opts[:collection]
      xls_xml_styles = opts[:xls_xml_styles]
      xls_xml_column_tags = opts[:xls_xml_column_tags]
      @xml_header = %Q{<?xml version="1.0" encoding="UTF-8"?>\n<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40">\n#{xls_xml_styles}<Worksheet ss:Name="Sheet1">\n<Table>\n#{xls_xml_column_tags}}
      @xml_footer = %Q{</Table>\n</Worksheet>\n</Workbook>\n}
    end

    def each
      yield @xml_header
      yield as_row(@headers)
      @collection.each { |record| yield as_row(record) }
      yield @xml_footer
    end

    private

    def as_cell(el)
      %{<Cell><Data ss:Type="String">#{el}</Data></Cell>}
    end

    def as_row(array)
      my_array = array.map{|a| as_cell(a)}.join("\n")
      "<Row>\n" + my_array + "\n</Row>\n"
    end
  end
end
