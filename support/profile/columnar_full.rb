loader = MIME::Types::Loader.new

50.times do
  loader.load(columnar: true).first.to_h
end
