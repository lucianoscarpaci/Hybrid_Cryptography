require 'openssl'

def bin2hex(s)
  mp = {
    '0000' => '0',
    '0001' => '1',
    '0010' => '2',
    '0011' => '3',
    '0100' => '4',
    '0101' => '5',
    '0110' => '6',
    '0111' => '7',
    '1000' => '8',
    '1001' => '9',
    '1010' => 'A',
    '1011' => 'B',
    '1100' => 'C',
    '1101' => 'D',
    '1110' => 'E',
    '1111' => 'F'
  }

  hex = ''
  (0..s.length - 1).step(4) do |i|
    ch = ''
    ch += s[i]
    ch += s[i + 1]
    ch += s[i + 2]
    ch += s[i + 3]
    hex += mp[ch]
  end
  hex
end

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
    subkeys = []
    subkeys << bin2hex(permutedchoice2_key.join)
    #Print the subkeys and check if they are valid or not
    puts "Subkey #{i + 1}: #{subkeys}"
    valid = subkeys.length == subkeys.uniq.length && subkeys.all?
    if valid
      puts "The provided subkeys meet the criteria."
    else
      puts "The provided subkeys do not meet the criteria."
    end
  end
end 

plaintext = '123456ABCD132536'
key = 'AABB09182736CCDD'

generate_subkeys(key)
puts
