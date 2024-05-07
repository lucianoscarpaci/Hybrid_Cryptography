require 'openssl'
require 'base64'
require 'dotenv/load'

MAX_PLAINTEXT_LENGTH = 100
MAX_ATTEMPTS = 5

class TripleDES
  attr_accessor :cipher, :key

  def initialize(cipher, key)
    @cipher = OpenSSL::Cipher.new('des-ede3-ecb')
    @key = [des3_rsa_key(ENV['KEY1'], ENV['PUBLIC_KEY'], ENV['RSA_KEY'])].pack('H*')
    @cipher.encrypt
    @cipher.key = @key
  end

  def encrypt_3des_ecb(message)
    encrypted = cipher.update(message) + cipher.final
    encrypted_message = Base64.strict_encode64(encrypted)
    return encrypted_message
  end

  def decrypt_3des_ecb(encrypted_message)
    cipher.decrypt
    cipher.key = key
    decoded = Base64.strict_decode64(encrypted_message)
    decrypted = cipher.update(decoded) + cipher.final
    return decrypted
  end

  private

  def des3_rsa_key(des_key1, pub_key, rsa_key)
    rsa_public_key = OpenSSL::PKey::RSA.new(pub_key)
    rsa_private_key = OpenSSL::PKey::RSA.new(rsa_key)
    encrypted_key = rsa_public_key.public_encrypt(des_key1)
    decrypted_key = rsa_private_key.private_decrypt(encrypted_key)
    hashed_key = OpenSSL::Digest::SHA256.digest(decrypted_key)[0, 24]
    decrypted_key = hashed_key.unpack('H*').first
    return decrypted_key
  end
end

def main
  des3 = TripleDES.new(@cipher, @key)
  attempts = MAX_ATTEMPTS

  loop do
    plaintext = ARGV[0..MAX_PLAINTEXT_LENGTH].join(' ')
    if plaintext.match?(/\A[A-Za-z\s]+\z/) && plaintext.length <= MAX_PLAINTEXT_LENGTH
      ciphertext = des3.encrypt_3des_ecb(plaintext)
      puts "\n\n The Ciphertext is: #{ciphertext}"
      decrypted = des3.decrypt_3des_ecb(ciphertext)
      return ciphertext
    elsif plaintext.match?(/\A[A-Za-z0-9+\/=]+\z/)
      plaintext = des3.decrypt_3des_ecb(plaintext)
      puts "The Plaintext is: #{plaintext}"
      return plaintext
    else
      attempts -= 1
      puts "Invalid plaintext! Please try again. You have #{attempts} attempts left."
      if attempts == 0
        puts 'Max attempts reached. Exiting...'
        break
      end
    end
  end
end


main if __FILE__ == $PROGRAM_NAME
