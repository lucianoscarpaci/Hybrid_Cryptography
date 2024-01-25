require 'openssl'
require 'base64'

# define the key and the IV for AES-256 bit
key = OpenSSL::Cipher.new('AES-256-CBC').random_key
iv = OpenSSL::Cipher.new('AES-256-CBC').random_iv
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
def encrypt(plaintext, key, iv)
	cipher = OpenSSL::Cipher.new('AES-256-CBC')
	cipher.encrypt
	cipher.key = key
	cipher.iv = iv
	encrypted = cipher.update(plaintext) + cipher.final
	return encrypted
end

def decrypt(ciphertext, key, iv)
	cipher = OpenSSL::Cipher.new('AES-256-CBC')
	cipher.decrypt
	cipher.key = key
	cipher.iv = iv
	decrypted = cipher.update(ciphertext) + cipher.final
	return decrypted
end

print 'Enter the message to be encrypted: '
plaintext = gets.chomp

# Encryption
ciphertext = encrypt(plaintext, key, iv)
puts "Ciphertext: #{ciphertext.unpack('H*').first}"

# Load the RSA public key
rsa_key = OpenSSL::PKey::RSA.generate(2048)
public_key = rsa_key.public_key

# encrypt the ciphertext using RSA public key
encrypted_cipher = public_key.public_encrypt(ciphertext)
header = "------ BEGIN RSA MESSAGE ------"
footer = "------ END RSA MESSAGE ------"
encoded_cipher = Base64.strict_encode64(encrypted_cipher)
block_length = 31
puts header
encoded_cipher.chars.each_slice(block_length) do |block|
	puts block.join
end
puts footer

# decode using base64
decoded_cipher = Base64.strict_decode64(encoded_cipher)

# Decryption
decrypted_cipher = rsa_key.private_decrypt(encrypted_cipher)
puts "Decrypted Ciphertext: #{decrypted_cipher.unpack('H*').first}"
decryptext = decrypt(decrypted_cipher, key, iv)
puts "Decryptext: #{decryptext}"


