# frozen_string_literal: true

loader = MIME::Types::Loader.new

50.times do
  loader.load(columnar: true)
end
