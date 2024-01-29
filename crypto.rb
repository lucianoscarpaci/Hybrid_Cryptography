require 'openssl'
require 'base64'

# define the key and the IV for AES-256 bit
aes_key = OpenSSL::Cipher.new('AES-256-CBC').random_key
aes_iv = OpenSSL::Cipher.new('AES-256-CBC').random_iv
# print the key from AES 256
# puts "Key: #{key.unpack('H*').first}"
# generate a new RSA key pair consisting of a public key and a private key
# def rsa_key_pair
#	rsa_key = OpenSSL::PKey::RSA.new(2048)
#	public_key = rsa_key.public_key
#	private_key = rsa_key
#	return public_key, private_key
# end
# print the public key from RSA
# puts "Public Key: #{rsa_key_pair[0].to_pem}"
# print the private key from RSA
# puts "Private Key: #{rsa_key_pair[1].to_pem}"
# the public key will be used for encryption, while the private key
# will be used for decryption.
rsa_key = OpenSSL::PKey::RSA.generate(2048)
def encrypt(plaintext, aes_key, aes_iv, rsa_key)
	aes_cipher = OpenSSL::Cipher.new('AES-256-CBC')
	aes_cipher.encrypt
	aes_cipher.key = aes_key
	aes_cipher.iv = aes_iv
	encrypted_data = aes_cipher.update(plaintext) + aes_cipher.final
	rsa_public_key = rsa_key.public_key
	encrypted_key = rsa_public_key.public_encrypt(aes_key)
	encoded_data = Base64.strict_encode64(encrypted_data)
	#block_length = 31
	#header = "------ BEGIN RSA MESSAGE ------"
	#block_encoded_data = encoded_data.scan(/.{1,#{block_length}}/).join("\n")
	#footer = "------ END RSA MESSAGE ------"
	#message_block = "#{header}\n\n#{block_encoded_data}\n\n#{footer}"
	encoded_key = Base64.strict_encode64(encrypted_key)
	#pub_header = "------ BEGIN RSA PUBLIC KEY ------"
	#block_encoded_key = encoded_key.scan(/.{1,#{block_length}}/).join("\n")
	#pub_footer = "------ END RSA PUBLIC KEY ------"
	#key_block = "#{pub_header}\n\n#{block_encoded_key}\n\n#{pub_footer}"
	return encoded_data, encoded_key
end

def decrypt(encoded_data, encoded_key, aes_iv, rsa_key)
	aes_key = rsa_key.private_decrypt(Base64.strict_decode64(encoded_key))
	aes_cipher = OpenSSL::Cipher.new('AES-256-CBC')
	aes_cipher.decrypt
	aes_cipher.key = aes_key
	aes_cipher.iv = aes_iv
	# decode first and then decrypt
	decrypted_data = aes_cipher.update(Base64.strict_decode64(encoded_data)) + aes_cipher.final
	return decrypted_data
end

print 'Enter the message to be encrypted: '
plaintext = gets.chomp

# Encryption
encoded_data, encoded_key = encrypt(plaintext, aes_key, aes_iv, rsa_key)
#puts "Ciphertext: #{ciphertext.unpack('H*').first}"
puts "#{encoded_data}"
puts "#{encoded_key}"

# Decryption
decrypted_data = decrypt(encoded_data, encoded_key, aes_iv, rsa_key)
puts "#{decrypted_data}"


