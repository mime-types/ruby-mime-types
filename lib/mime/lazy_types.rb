require 'mime/lazy_type'

module MIME::LazyTypes
  ROOT = File.expand_path('../../../data', __FILE__).freeze
  LOAD_MUTEX = Mutex.new

  def self.extended(obj)
    super
    obj.instance_variable_set(:@mime_types, [])
    obj.instance_variable_set(:@loaded_attributes, [])
  end

  def _each_file_line(type, lookup=true)
    LOAD_MUTEX.synchronize do
      next if @loaded_attributes.include?(type)
      File.open(File.join(ROOT, "mime-types-#{type}.txt"), 'r:UTF-8') do |file|
        i = -1
        file.each_line do |type_line|
          if lookup
            next unless mime_type = @mime_types[i+=1]
            yield mime_type, type_line.chomp
          else
            yield type_line.chomp
          end
        end
      end
      @loaded_attributes << type
    end
  end

  def _load_base_data
    _each_file_line('content_type', false) do |type_line|
      content_type, *extensions = type_line.split
      type = MIME::LazyType.new(self, content_type, extensions)
      @mime_types << type
      add(type)
    end
    self
  end
    
  def _load_friendly
    en = 'en'.freeze
    _each_file_line('friendly') do |mime_type, type_line|
      mime_type.friendly = type_line.empty? ? nil : {en=>type_line}
    end
  end
    
  def _load_encoding
    _each_file_line('encoding') do |mime_type, type_line|
      mime_type.encoding = type_line
    end
  end
    
  def _load_docs
    empty = '-'
    _each_file_line('docs') do |mime_type, type_line|
      mime_type.docs = type_line == empty ? [] : type_line
    end
  end
    
  def _load_obsolete
    one = '1'
    _each_file_line('obsolete') do |mime_type, type_line|
      mime_type.obsolete = type_line == one ? true : nil
    end
  end
    
  def _load_references
    empty = '-'
    pipe = '|'
    _each_file_line('references') do |mime_type, type_line|
      mime_type.instance_variable_set(:@references, type_line == empty ? [] : type_line.split(pipe).flatten.compact.uniq)
    end
  end

  def _load_registered
    one = '1'
    _each_file_line('registered') do |mime_type, type_line|
      mime_type.registered = type_line == one
    end
  end
    
  def _load_signature
    one = '1'
    _each_file_line('signature') do |mime_type, type_line|
      mime_type.signature = type_line == one
    end
  end

  def _load_system
    empty = '-'
    _each_file_line('system') do |mime_type, type_line|
      mime_type.system = (type_line unless type_line == empty)
    end
  end
    
  def _load_xrefs
    empty = '-'
    pipe = '|'
    caret = '^'
    _each_file_line('xrefs') do |mime_type, type_line|
      mime_type.xrefs = type_line == empty ? {} : type_line.split(pipe).inject({}){|h, line| k, *v = line.split(caret); v = [nil] if v.empty?; h[k] = v; h}
    end
  end

  def _load_use_instead
    empty = '-'
    pipe = '|'
    _each_file_line('use_instead') do |mime_type, type_line|
      mime_type.use_instead = ((type_line =~ /\A\|/ ? type_line[1..-1].split(pipe) : type_line) unless type_line == empty)
    end
  end

end
