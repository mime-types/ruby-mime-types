#!/usr/bin/ruby -w

require 'rubygems'
require 'open-uri'
require 'nokogiri'

index = %q(http://www.iana.org/assignments/media-types/)
type_indexes = {}

puts "Downloading index of MIME types from #{index}"
mime_index = Nokogiri::HTML(open(index) { |f| f.read })
mime_index.xpath('//p/a').each do |tag|
  next unless tag['href'] =~ %r{^/assignments}
  url = tag['href'].sub(%r{^/assignments/media-types/}, '')
  type_indexes[tag.content] = File.join(index, url)
end

type_indexes.each { |name, url|
  puts "Downloading #{name} from #{url}"
  File.open("#{name}.html", "wb") { |w|
    w.write open(url) { |f| f.read }
  }
}
