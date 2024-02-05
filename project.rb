require 'openssl'
require 'base64'
# define the key and the IV for AES-256 bit
# define the RSA-2048 bit keypair
aes_key = OpenSSL::Cipher.new('AES-256-CBC').random_key
aes_iv = OpenSSL::Cipher.new('AES-256-CBC').random_iv
rsa_key = OpenSSL::PKey::RSA.generate(2048)

class HybridCrypto
	def initialize(aes_key, aes_iv, rsa_key)
		@aes_key = aes_key
		@aes_iv = aes_iv
		@rsa_key = rsa_key
	end

	def encrypt(plaintext)
		aes_cipher = OpenSSL::Cipher.new('AES-256-CBC')
		aes_cipher.encrypt
		aes_cipher.key = @aes_key
		aes_cipher.iv = @aes_iv
		encrypted_data = aes_cipher.update(plaintext) + aes_cipher.final
		rsa_public_key = @rsa_key.public_key
		encrypted_key = rsa_public_key.public_encrypt(@aes_key)
		encoded_data = Base64.strict_encode64(encrypted_data)
		encoded_key = Base64.strict_encode64(encrypted_key)
		return encoded_data, encoded_key
	end

	def decrypt(encoded_data, encoded_key)
		decoded_key = Base64.strict_decode64(encoded_key)
		decoded_data = Base64.strict_decode64(encoded_data)
		aes_key = @rsa_key.private_decrypt(decoded_key)
		aes_cipher = OpenSSL::Cipher.new('AES-256-CBC')
		aes_cipher.decrypt
		aes_cipher.key = aes_key
		aes_cipher.iv = @aes_iv
		decrypted_data = aes_cipher.update(decoded_data) + aes_cipher.final
		return decrypted_data
	end
end

MAX_PLAINTEXT_LENGTH = 100
MAX_BLOCK_LENGTH = 31
MAX_ATTEMPTS = 5
hybrid_crypto = HybridCrypto.new(aes_key, aes_iv, rsa_key)
attempts = MAX_ATTEMPTS
loop do
	puts "------ BEGIN PLAINTEXT ------\n\n"
	plaintext = gets.chomp.strip

	if plaintext.match?(/\A[A-Za-z\s]+\z/) && plaintext.length <= MAX_PLAINTEXT_LENGTH
		block_length = MAX_BLOCK_LENGTH
		puts "\n------ END PLAINTEXT ------"
		encoded_data, encoded_key = hybrid_crypto.encrypt(plaintext)
		header = "------ BEGIN RSA MESSAGE ------"
		block_encoded_data = encoded_data.scan(/.{1,#{block_length}}/).join("\n")
		footer = "------ END RSA MESSAGE ------"
		message_block = "#{header}\n\n#{block_encoded_data}\n\n#{footer}"
		puts "#{message_block}"
		pub_header = "------ BEGIN RSA PUBLIC KEY ------"
		block_encoded_key = encoded_key.scan(/.{1,#{block_length}}/).join("\n")
		pub_footer = "------ END RSA PUBLIC KEY ------"
		key_block = "#{pub_header}\n\n#{block_encoded_key}\n\n#{pub_footer}"
		puts "#{key_block}"
		decrypted_data = hybrid_crypto.decrypt(encoded_data, encoded_key)
		dec_header = "------ BEGIN DECRYPTED MESSAGE ------"
		block_decrypted_data = decrypted_data.scan(/.{1,#{block_length}}/).join("\n")
		dec_footer = "------ END DECRYPTED MESSAGE ------"
		decrypt_block = "#{dec_header}\n\n#{block_decrypted_data}\n\n#{dec_footer}"
		puts "#{decrypt_block}"
		return message_block, key_block, decrypt_block
	else
		attempts -= 1
		puts "Invalid plaintext! Please try again. You have #{attempts} attempts left."
	end
	break if attempts == 0
end
