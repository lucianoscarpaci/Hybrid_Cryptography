require 'openssl'
require 'base64'
require 'dotenv/load'

MAX_PLAINTEXT_LENGTH = 100
MAX_ATTEMPTS = 5

class AESRSA
  attr_accessor :cipher, :key, :iv

  def initialize(cipher, key, iv)
    @cipher = OpenSSL::Cipher.new('AES-256-CBC')
    @key = [aes_rsa_key(ENV['AES_KEY'], ENV['PUBLIC_KEY'], ENV['RSA_KEY'])].pack('H*')
    @iv = [generate_iv(ENV['AES_IV'])].pack('H*')
    @cipher.encrypt
    @cipher.key = @key
    @cipher.iv = @iv
  end

  def encrypt(plaintext)
    encrypted_data = cipher.update(plaintext) + cipher.final
    encrypted_message = Base64.strict_encode64(encrypted_data)
    return encrypted_message
  end

  def decrypt(encrypted_message)
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    plaintext = Base64.strict_decode64(encrypted_message)
    plaintext = cipher.update(plaintext) + cipher.final
    return plaintext
  end

  private

  def aes_rsa_key(aes_key, pub_key, rsa_key)
    rsa_public_key = OpenSSL::PKey::RSA.new(pub_key)
    rsa_private_key = OpenSSL::PKey::RSA.new(rsa_key)
    encrypted_key = rsa_public_key.public_encrypt(aes_key)
    decrypted_key = rsa_private_key.private_decrypt(encrypted_key)
    hashed_key = OpenSSL::Digest::SHA256.digest(decrypted_key)[0, 32]
    decrypted_key = hashed_key.unpack('H*').first
    return decrypted_key
  end

  def generate_iv(iv)
    hashed_iv = OpenSSL::Digest::SHA256.digest(iv)[0, 16]
    hashed_iv = hashed_iv.unpack('H*').first
    return hashed_iv
  end
end

def main
  aes_rsa = AESRSA.new(@cipher, @key, @iv)
  attempts = MAX_ATTEMPTS

  loop do
    plaintext = ARGV[0..MAX_PLAINTEXT_LENGTH].join(' ')
    if plaintext.match?(/\A[A-Za-z\s]+\z/) && plaintext.length <= MAX_PLAINTEXT_LENGTH
      ciphertext = aes_rsa.encrypt(plaintext)
      puts "\n\n The Ciphertext is: #{ciphertext}"
      decrypted = aes_rsa.decrypt(ciphertext)
      return ciphertext
    elsif plaintext.match?(/\A[A-Za-z0-9+\/=]+\z/)
      plaintext = aes_rsa.decrypt(plaintext)
      puts "The Plaintext is: #{plaintext}"
      return plaintext
    else
      attempts -= 1
      puts "Invalid plaintext! Please try again. You have #{attempts} attempts left."
      if attempts == 0
        puts 'No more attempts left. Exiting...'
        break
      end
    end
  end
end

main if __FILE__ == $PROGRAM_NAME