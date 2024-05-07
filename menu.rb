require 'tty-prompt'
require 'tty-command'

# create a tty prompt
prompt = TTY::Prompt.new

menu_options = [
  { name: 'pub: RSA-2048 sym: AES-256, mode: CBC', value: 'aes_rsa'},
  { name: 'pub: RSA-2048 sym: 3DES, mode: ECB', value: '3des_rsa'},
  { name: 'pub: ECC-prime256v1 sym: AES-256, mode: CBC', value: 'ecc_aes' },
  { name: 'pub: ECC-prime256v1 sym: Blowfish, mode: CBC', value: 'ecc_blowfish'},
  { name: 'quit', value: 'exit'}
]

selected_option = prompt.select('Choose an option:', menu_options)

case selected_option
when 'aes_rsa'
  puts "Enter 'e' for encryption or 'd' for decryption: "
  choice = gets.chomp.downcase
  case choice
  when 'e'
    puts "Enter the english plaintext: "
    plaintext = gets.chomp
    prompt.keypress("Press any key to continue...")

    cmd = TTY::Command.new
    cmd.run("ruby aes_rsa.rb #{plaintext}")
  when 'd'
    puts "Enter the encoded ciphertext: "
    ciphertext = gets.chomp
    prompt.keypress("Press any key to continue...")

    cmd = TTY::Command.new
    cmd.run("ruby aes_rsa.rb #{ciphertext}")
  else
    puts "The choice was invalid. Enter 'e' or 'd' "
  end
when '3des_rsa'
  puts "Enter 'e' for encryption or 'd' for decryption: "
  choice = gets.chomp.downcase
  case choice
  when 'e'
    puts "Enter the english plaintext: "
    plaintext = gets.chomp
    prompt.keypress("Press any key to continue...")

    cmd = TTY::Command.new
    cmd.run("ruby 3des_rsa.rb #{plaintext}")
  when 'd'
    puts "Enter the encoded ciphertext: "
    ciphertext = gets.chomp
    prompt.keypress("Press any key to continue...")
    
    cmd = TTY::Command.new
    cmd.run("ruby 3des_rsa.rb #{ciphertext}")
  else
    puts "The choice was invalid. Enter 'e' or 'd' "
  end
when 'ecc_aes'
  puts "Enter 'e' for encryption or 'd' for decryption: "
  choice = gets.chomp.downcase
  case choice
  when 'e'
    puts "Enter the english plaintext: "
    plaintext = gets.chomp
    prompt.keypress("Press any key to continue...")

    cmd = TTY::Command.new
    cmd.run("ruby ecc_aes.rb #{plaintext}")
  when 'd'
    puts "Enter the encoded ciphertext: "
    ciphertext = gets.chomp
    prompt.keypress("Press any key to continue...")
    
    cmd = TTY::Command.new
    cmd.run("ruby ecc_aes.rb #{ciphertext}")
  else
    puts "The choice was invalid. Enter 'e' or 'd' "
  end
when 'ecc_blowfish'
  puts "Enter 'e' for encryption or 'd' for decryption: "
  choice = gets.chomp.downcase
  case choice
  when 'e'
    puts "Enter the english plaintext: "
    plaintext = gets.chomp
    prompt.keypress("Press any key to continue...")

    cmd = TTY::Command.new
    cmd.run("ruby ecc_blowfish.rb #{plaintext}")
  when 'd'
    puts "Enter the encoded ciphertext: "
    ciphertext = gets.chomp
    prompt.keypress("Press any key to continue...")

    cmd = TTY::Command.new
    cmd.run("ruby ecc_blowfish.rb #{ciphertext}")
  else
    puts "The choice was invalid. Enter 'e' or 'd' "
  end
when 'exit'
  exit
end