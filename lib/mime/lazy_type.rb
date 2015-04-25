class MIME::LazyType < MIME::Type
  attr_reader :content_type, :extensions
  attr_writer :friendly

  def initialize(container, content_type, extensions)
    @container = container
    self.content_type = content_type
    self.extensions = extensions
  end

  LANG_EN = 'en'.freeze
  def friendly(lang = LANG_EN)
    @container._load_friendly unless defined?(@friendly)
    super if @friendly
  end

  def encoding
    @container._load_encoding unless defined?(@encoding)
    @encoding
  end

  def docs
    @container._load_docs unless defined?(@docs)
    @docs
  end

  def obsolete?
    @container._load_obsolete unless defined?(@obsolete)
    super
  end

  def references
    @container._load_references unless defined?(@references)
    @references
  end

  def registered?
    @container._load_registered unless defined?(@registered)
    super
  end

  def signature?
    @container._load_signature unless defined?(@signature)
    super
  end

  def system?(__internal__ = false)
    @container._load_system unless defined?(@system)
    super
  end

  def system
    @container._load_system unless defined?(@system)
    @system
  end

  def xrefs
    @container._load_xrefs unless defined?(@xrefs)
    @xrefs
  end

  def use_instead
    @container._load_use_instead unless defined?(@use_instead)
    @use_instead
  end

  def binary?
    @container._load_encoding unless defined?(@encoding)
    super
  end

  def to_a
    @container._load_encoding unless defined?(@encoding)
    @container._load_system unless defined?(@system)
    @container._load_docs unless defined?(@docs)
    @container._load_references unless defined?(@references)
    super
  end

  def to_hash
    @container._load_encoding unless defined?(@encoding)
    @container._load_system unless defined?(@system)
    @container._load_docs unless defined?(@docs)
    @container._load_references unless defined?(@references)
    super
  end

  def encode_with(coder)
    @container._load_friendly unless defined?(@friendly)
    @container._load_encoding unless defined?(@encoding)
    @container._load_system unless defined?(@system)
    @container._load_docs unless defined?(@docs)
    @container._load_references unless defined?(@references)
    @container._load_obsolete unless defined?(@obsolete)
    @container._load_use_instead unless defined?(@use_instead)
    @container._load_xrefs unless defined?(@xrefs)
    @container._load_system unless defined?(@system)
    @container._load_registered unless defined?(@registered)
    @container._load_signature unless defined?(@signature)
    super
  end

end
