# -*- ruby encoding: utf-8 -*-

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'fileutils'
require 'yaml'

ENV['RUBY_MIME_TYPES_LAZY_LOAD'] = 'yes'
require 'mime/types'

class IANADownloader
  INDEX_URL = %q(https://www.iana.org/assignments/media-types/)
  MIME_HREF = %r{/assignments/media-types/(.+)/?$}

  def self.download_to(destination)
    new(destination).download_all
  end

  attr_reader :destination

  def initialize(destination = nil)
    @destination =
      File.expand_path(destination ||
                       File.expand_path('../../type-lists', __FILE__))
  end

  def download_all
    puts "Downloading index of MIME types from #{INDEX_URL}."
    index = Nokogiri::HTML(open(INDEX_URL) { |f| f.read })
    index.xpath('//a').each do |tag|
      next unless tag['href']
      href_match = MIME_HREF.match(tag['href'])
      next unless href_match
      href = href_match.captures.first
      next if tag.content == 'example'
      download_one(href, tag.content, href)
    end
  end

  def download_one(url, name = url, type = nil)
    if url =~ %r{^https?://}
      name = File.basename(url) if name == url
    else
      url  = File.join(INDEX_URL, url)
    end

    Parser.download(name, from: url, to: @destination, type: type)
  end
end

class IANADownloader::Parser
  def self.download(name, options = {})
    new(name, options) do |parser|
      parser.parse(parser.download)
      parser.save
    end
  end

  def initialize(name, options = {})
    raise ArgumentError, ":from not specified" unless options[:from]
    raise ArgumentError, ":to not specified" unless options[:to]

    @name  = "#{File.basename(name, '.yml')}.yml"
    @from  = options[:from]
    @to    = File.expand_path(options[:to])
    @type  = File.basename(options[:type] || name, '.yml')
    @file  = File.join(@to, @name)
    @types = load_mime_types || MIME::Types.new

    yield self if block_given?
  end

  def download
    puts "Downloading #{@name} from #{@from}"
    Nokogiri::HTML(open(@from) { |f| f.read })
  end

  def parse(html)
    nodes = html.xpath('//table//table//tr')

    # How many <td> children does the first node have?
    node_count = child_elems(nodes.first).size

    if node_count == 1
      # The title node doesn't have what we expect. Let's try it based on
      # the first real node.
      node_count = child_elems(nodes.first.next).size
    end

    nodes.each do |node|
      next if node == nodes.first

      elems = child_elems(node)
      next if elems.size.zero?

      if elems.size != node_count
        warn "size mismatch (#{elems.size} != #{node_count}) in node: #{node}"
        next
      end

      sub_ix, ref_ix = case elems.size
                       when 3
                         [ 1, 2 ]
                       when 4
                         [ 1, 3 ]
                       else
                         warn "size error (#{elems.size} != {3,4}) in node: #{node}"
                         raise
                       end
      subtype = elems[sub_ix].content.chomp.strip
      refs    = child_elems(elems[ref_ix]).map { |ref|
        ref = ref.xpath('a') unless ref.name == 'a'
        [ ref ].flatten.map { |r| href_to_ref(r) }

      }.flatten

      content_type = [ @type, subtype].join('/')
      use_instead  = nil
      obsolete     = false

      if content_type =~ OBSOLETE
        content_type = $1
        obsolete     = true
      elsif content_type =~ DEPRECATED
        content_type = $1
        use_instead  = [ $2 ]
        obsolete     = true
      end

      types        = @types.select { |t|
        (t.content_type == content_type)
      }

      if types.empty?
        MIME::Type.new(content_type) do |mt|
          mt.references  = %w(IANA) + refs
          mt.registered  = true
          mt.obsolete    = obsolete if obsolete
          mt.use_instead = use_instead if use_instead
          @types << mt
        end
      else
        types.each { |mt|
          mt.references  = %w(IANA) + refs
          mt.registered  = true
          mt.obsolete    = obsolete if obsolete
          mt.use_instead = use_instead if use_instead
        }
      end
    end
  end

  def save
    FileUtils.mkdir_p(@to)
    File.open(@file, 'wb') { |f|
      f.puts @types.map.to_a.sort.to_yaml
    }
  end

  private
  def child_elems(node)
    node.children.select { |n| n.elem? }
  end

  def load_mime_types
    if File.exist?(@file)
      MIME::Types::Loader.load_from_yaml(@file)
    end
  end

  def href_to_ref(ref)
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
    when RFC_BAD_EDITOR
      ref.content
    when %r{(https?://.*)}
      "{#{ref.content}=#$1}"
    else
      ref
    end
  end

  CONTACT_PEOPLE = %r{https?://www.iana.org/assignments/contact-people.html?l?#(.*)}
  RFC_EDITOR = %r{https?://www.rfc-editor.org/rfc/rfc(\d+).txt}
  RFC_BAD_EDITOR = %r{https?://www.rfc-editor.org/rfc/rfcxxxx.txt}
  IETF_RFC = %r{https?://www.ietf.org/rfc/rfc(\d+).txt}
  IETF_RFC_TOOLS = %r{https?://tools.ietf.org/html/rfc(\d+)}
  OBSOLETE   = %r{(.+)\s+\((?:obsolete|deprecated)\)}i
  DEPRECATED = %r{(.+)\s+-\s+DEPRECATED\s+-\s+Please\s+use\s+(.+)}
end
