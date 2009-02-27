#!/usr/bin/ruby -w

require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'cgi'

class IANAParser
  include Comparable

  INDEX = %q(http://www.iana.org/assignments/media-types/)
  CONTACT_PEOPLE = %r{http://www.iana.org/assignments/contact-people.html?#(.*)}
  RFC_EDITOR = %r{http://www.rfc-editor.org/rfc/rfc(\d+).txt}
  IETF_RFC = %r{http://www.ietf.org/rfc/rfc(\d+).txt}
  IETF_RFC_TOOLS = %r{http://tools.ietf.org/html/rfc(\d+)}

  class << self
    def load_index
      @types ||= {}

      Nokogiri::HTML(open(INDEX) { |f| f.read }).xpath('//p/a').each do |tag|
        href_match = %r{^/assignments/media-types/(.+)/$}.match(tag['href'])
        next if href_match.nil?
        type = href_match.captures[0]
        @types[tag.content] = IANAParser.new(tag.content, type)
      end
    end

    attr_reader :types
  end

  def initialize(name, type)
    @name = name
    @type = type
    @url  = File.join(INDEX, @type)
  end

  attr_reader :name
  attr_reader :type
  attr_reader :url
  attr_reader :html

  def download(name = nil)
    if name
      @html = Nokogiri::HTML(open(name) { |f| f.read })
    else
      @html = Nokogiri::HTML(open(@url) { |f| f.read })
    end
  end

  def save_html
    File.open("#@name.html", "wb") { |w| w.write @html }
  end

  def <=>(o)
    self.name <=> o.name
  end

  def parse
    nodes = html.xpath("//table//table//tr")

    # How many <td> children does the first node have?
    node_count = nodes.first.children.select { |node| node.elem? }.size

    @mime_types = nodes.map do |node|
      next if node == nodes.first
      elems = node.children.select { |n| n.elem? }
      next if elems.size.zero?
      raise "size mismatch #{elems.size} != #{node_count}" if node_count != elems.size

      case elems.size
      when 3
        subtype_index = 1
        refnode_index = 2
      when 4
        subtype_index = 1
        refnode_index = 3
      else
        raise "Unknown element size."
      end

      subtype   = elems[subtype_index].content.chomp.strip
      refnodes  = elems[refnode_index].children.select { |n| n.elem? }.map { |ref|
        case ref['href']
        when CONTACT_PEOPLE
          tag = CGI::unescape($1).chomp.strip
          if tag == ref.content
            "[#{ref.content}]"
          else
            "[#{ref.content}=#{tag}]"
          end
        when RFC_EDITOR, IETF_RFC, IETF_RFC_TOOLS
          "RFC#$1"
        when %r{(https?://.*)}
          "{#{ref.content}=#$1}"
        else
          ref
        end
      }
      refs = refnodes.join(',')

      "#@type/#{subtype} 'IANA,#{refs}"
    end.compact

    @mime_types
  end

  def save_text
    File.open("#@name.txt", "wb") { |w| w.write @mime_types.join("\n") }
  end
end

puts "Downloading index of MIME types from #{IANAParser::INDEX}."
IANAParser.load_index

IANAParser.types.values.sort.each do |parser|
  next if parser.name == "example" or parser.name == "mime"
  puts "Downloading #{parser.name} from #{parser.url}"
  parser.download
  puts "Saving #{parser.name}.html"
  parser.save_html
  puts "Parsing #{parser.name}"
  parser.parse
  puts "Saving #{parser.name}.txt"
  parser.save_text
end

# foo = IANAParser.types['application']
# foo.download("application.html")
# foo.parse
# foo = IANAParser.types['image']
# foo.download("image.html")
# foo.parse
