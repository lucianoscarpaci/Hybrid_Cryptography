subkeys = [
  "001FE1E1801400",
  "003FC3C3002800",
  "00FF0F0C00A000",
  "03FC3C00028003",
  "0FF0F0000A000C",
  "3FC3C000280030",
  "FF0F0000A000C0",
  "FC3C0032800300",
  "F8780075000600",
  "E1E001F4001801",
  "878007F0006005",
  "1E001FE0018014",
  "78007F80060050",
  "E001FE10180140",
  "8007F870600500",
  "000FF0F0C00A00"
]

valid = subkeys.length == subkeys.uniq.length && subkeys.all?

if valid
  puts "The provided subkeys meet the criteria."
else
  puts "The provided subkeys do not meet the criteria."
end