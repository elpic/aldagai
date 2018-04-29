module Aldagai
  class Encryptor

    def initialize(secret)
      @secret = secret
    end

    def encrypt(plain)
      cipher = OpenSSL::Cipher::AES256.new(:CBC).encrypt
      cipher.key = Digest::SHA256.digest(@secret)

      (cipher.update(plain) + cipher.final).unpack('H*')[0].upcase
    end

    def decrypt(encrypted)
      cipher = OpenSSL::Cipher::AES256.new(:CBC).decrypt
      cipher.key = Digest::SHA256.digest(@secret)

      string = [encrypted].pack('H*').unpack('C*').pack('c*')

      cipher.update(string) + cipher.final
    end

  end
end
