require 'openssl'


def generate_subkeys(key)
  key = key.unpack1('B64')
  permuted_key = [57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18,
                  10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36,
                  63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22,
                  14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4]

  shifted_bits = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]

  permutedchoice1_left = []
  permutedchoice1_right = []
  permutedchoice2 = []

  # Create Permuted choice 1 (PC1) keys
  28.times do |i|
    permutedchoice1_left << key[permuted_key[i] - 1]
    permutedchoice1_right << key[permuted_key[i + 28] - 1]
  end

  # Generate 16 rounds of subkeys
  # shifting the bits to the left each time by the number of bits in shifted_bits array
  shifted_bits.each_with_index do |n, i|
    permutedchoice1_left.rotate!(n)
    permutedchoice1_right.rotate!(n)
    # combination of the left and right strings
    permutedchoice2_key = permutedchoice1_left + permutedchoice1_right
    #  [14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8,
    #   16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33,
    #   48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32] # Permuted choice 2 (PC2) table
    #
    # Compression of the key from 56 bits to 48 bits
    permutedchoice2_key.each { |bit| permutedchoice2 << bit }
    #Print the subkeys and check if they are valid or not
    puts "Subkey #{i + 1}: #{permutedchoice2_key.join}"
  end
end 

plaintext = '123456ABCD132536'
key = 'AABB09182736CCDD'

generate_subkeys(key)
puts
