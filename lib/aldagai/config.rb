module Aldagai
  class Config

    def secret
      ENV['ALDAGAI_SECRET'] || read_secret_from_file
    end

    private

    def read_secret_from_file
      path = File.expand_path('./.aldagai.secret')

      if File.exists?(path)
        File.read(path)
      else
        nil
      end
    end

  end
end
