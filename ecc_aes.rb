require 'base64'
require 'openssl'
require 'dotenv/load'

MAX_BUFFER_LENGTH = 100
MAX_ATTEMPTS = 5

class ECC
	attr_accessor :cipher, :key, :iv

	def initialize(cipher, key, iv)
		@cipher = OpenSSL::Cipher.new('AES-256-CBC')
		@key = [generate_shared_secret(ENV['ECC_PRIVATE_KEY'], ENV['ECC_PUBLIC_KEY'])].pack('H*')
		@iv = [generate_iv(ENV['AES_IV'])].pack('H*')
		@cipher.encrypt
		@cipher.key = @key
		@cipher.iv = @iv
	end

	def encryption_scheme(plaintext)
		ciphertext = cipher.update(plaintext) + cipher.final
		ciphertext = Base64.strict_encode64(ciphertext)
		return ciphertext
	end

	def decryption_scheme(ciphertext)
		cipher.decrypt
		cipher.key = key
		cipher.iv = iv
		plaintext = Base64.strict_decode64(ciphertext)
		plaintext = cipher.update(plaintext) + cipher.final
		return plaintext
	end

	private

	def generate_shared_secret(ecc_key, pub_key)
		ecc_public_key = OpenSSL::PKey::EC.new('prime256v1')
		ecc_public_key.public_key = OpenSSL::PKey::EC::Point.new(ecc_public_key.group, OpenSSL::BN.new(pub_key, 16)) 
		ecc_private_key = OpenSSL::PKey::EC.new('prime256v1')
		ecc_private_key.private_key = OpenSSL::BN.new(ecc_key, 2)
		secret = ecc_private_key.dh_compute_key(ecc_public_key.public_key)
		secret = OpenSSL::Digest::SHA256.digest(secret)[0, 32]
		secret = secret.unpack('H*').first
		return secret	
	end

	def generate_iv(iv)
		hashed_iv = OpenSSL::Digest::SHA256.digest(iv)[0, 16]
		hashed_iv = hashed_iv.unpack('H*').first
		return hashed_iv
	end
end

def main
	ecc = ECC.new(@cipher, @key, @iv)
	attempts = MAX_ATTEMPTS

	loop do
		plaintext = ARGV[0..MAX_BUFFER_LENGTH].join(' ')
		if plaintext.match?(/\A[A-Za-z\s]+\z/) && plaintext.length <= MAX_BUFFER_LENGTH
			encrypted_message = ecc.encryption_scheme(plaintext)
			puts "The ciphertext is: #{encrypted_message}"
			decrypted_message = ecc.decryption_scheme(encrypted_message)
			return encrypted_message
		elsif plaintext.match?(/\A[A-Za-z0-9+\/=]+\z/)
			plaintext = ecc.decryption_scheme(plaintext)
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