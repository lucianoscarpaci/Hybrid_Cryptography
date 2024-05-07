require 'openssl'
require 'base64'
require 'dotenv/load'

MAX_PLAINTEXT_LENGTH = 100
MAX_ATTEMPTS = 5

class BLOWFISH
  attr_accessor :cipher, :key, :iv

  def initialize(cipher, key, iv)
    @cipher = OpenSSL::Cipher.new('bf-cbc')
    @key = [generate_shared_secret(ENV['ECC_PRIVATE_KEY'], ENV['ECC_PUBLIC_KEY'])].pack('H*')
    @iv = [generate_iv("0123456789abcdef")].pack('H*')
    @cipher.encrypt
    @cipher.key = @key
    @cipher.iv = @iv
  end

  def encrypt_blowfish(message)
    numbers = convert_to_numbers(message)
    encrypted = cipher.update(numbers) + cipher.final
    encrypted_message = Base64.strict_encode64(encrypted)
    return encrypted_message
  end

  def decrypt_blowfish(encrypted_message)
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    decoded = Base64.strict_decode64(encrypted_message)
    decrypted = cipher.update(decoded) + cipher.final
    plaintext = convert_to_message(decrypted)
    return plaintext
  end

  private

  def convert_to_numbers(input)
    alphabet = ('a'..'z').to_a
    number_map = {}

    alphabet.each_with_index do |char, index|
      number_map[char] = index + 1
    end

    numbers = input.downcase.chars.map do |char|
      if char == ' '
        0  
      else
        number_map[char] || 0  
      end
    end

    binary_numbers = numbers.map { |num| num.to_s(2) }
    binary_numbers.join(' ')
  end

  def convert_to_message(numbers)
    
    alphabet = ('a'..'z').to_a
    number_map = {}
    result = []

    alphabet.each_with_index do |char, index|
      number_map[(index + 1).to_s] = char
    end

    numbers.split.each do |num|
      decimal_num = num.to_i(2)
      if decimal_num.zero?
        result << ' '
      else
        result << number_map[decimal_num.to_s]
      end
    end

    result.join('')
  end  
    
  def generate_shared_secret(ecc_key, pub_key)
    ecc_public_key = OpenSSL::PKey::EC.new('prime256v1')
    ecc_public_key.public_key = OpenSSL::PKey::EC::Point.new(ecc_public_key.group, OpenSSL::BN.new(pub_key, 16))
    ecc_private_key = OpenSSL::PKey::EC.new('prime256v1')
    ecc_private_key.private_key = OpenSSL::BN.new(ecc_key, 2)
    secret = ecc_private_key.dh_compute_key(ecc_public_key.public_key)
    secret = OpenSSL::Digest::SHA256.digest(secret)[0, 16]
    secret = secret.unpack('H*').first
    return secret
  end

  def generate_iv(iv)
    hashed_iv = OpenSSL::Digest::SHA256.digest(iv)[0, 8]
    hashed_iv = hashed_iv.unpack('H*').first
    return hashed_iv
  end
end

def main
  blowfish = BLOWFISH.new(@cipher, @key, @iv)
  attempts = MAX_ATTEMPTS

  loop do
    plaintext = ARGV[0..MAX_PLAINTEXT_LENGTH].join(' ')
    if plaintext.match?(/\A[A-Za-z\s]+\z/) && plaintext.length <= MAX_PLAINTEXT_LENGTH
      encrypted_message = blowfish.encrypt_blowfish(plaintext)
      puts "The ciphertext is: #{encrypted_message}"

      decrypted_message = blowfish.decrypt_blowfish(encrypted_message)

      return encrypted_message
    elsif plaintext.match?(/\A[A-Za-z0-9+\/=]+\z/)
      plaintext = blowfish.decrypt_blowfish(plaintext)
      puts "The plaintext is: #{plaintext}"
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