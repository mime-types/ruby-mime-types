require "net/http"
require "json"

class Deps
  def self.run(args)
    new.run(args)
  end

  def run(args)
    deps = rubygems_get(gem_name: "mime-types", endpoint: "reverse_dependencies")
    weighted_deps = {}

    deps.each do |name|
      begin
        downloads = gem_downloads(name)
        weighted_deps[name] = downloads if downloads
      rescue => e
        puts "#{name} #{e.message}"
      end
    end

    weighted_deps
      .sort { |(_k1, v1), (_k2, v2)| v2 <=> v1 }
      .first(args.number || 50)
      .each_with_index do |(k, v), i|
      puts "#{i}) #{k}: #{v}"
    end
  end

  private

  def rubygems_get(gem_name: "", endpoint: "")
    path = File.join("/api/v1/gems/", gem_name, endpoint).chomp("/") + ".json"
    Net::HTTP.start("rubygems.org", use_ssl: true) do |http|
      JSON.parse(http.get(path).body)
    end
  end

  def gem_downloads(name)
    rubygems_get(gem_name: name)["downloads"]
  rescue => e
    puts "#{name} #{e.message}"
  end
end
