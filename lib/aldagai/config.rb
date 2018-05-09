module Aldagai
  class Config

    def secret
      ENV['ALDAGAI_SECRET'] || read_secret_from_file
    end

    private

    def read_secret_from_file
      IO.binread(key_path).strip if File.exists?(key_path)
    end

    def key_path
      File.expand_path('./.aldagai.secret')
    end

  end
end
