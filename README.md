# CIS-5371

The one page description of the architecture of the code is in the
Microsoft Word document "A hybrid Cryptographic Implementation.docx" in the CIS-5371 directory.

Usage

Install all the required software packages in the Gemfile by running:

```ruby bundle install```

Create a .env file in the CIS-5371 directory with the following enviroment variables inside:

For ECC:
ECC_PUBLIC_KEY=, ECC_PRIVATE_KEY=,

For AES:
AES_KEY=, AES_IV=,

For Triple DES:
DES_KEY=,

For RSA:
RSA_KEY=, PUBLIC_KEY=,

After all is successful to run the program, run the following command:

```ruby menu.rb``` - the main program User Interface to run all the algorithms.

Hybrid crypto 3des_rsa:
<img src="./gifs/3des_rsa_encryption.gif">

Hybrid crypto aes_rsa:
<img src="./gifs/aes_rsa_encryption.gif">

Hybrid crypto ecc_aes:
<img src="./gifs/ecc_aes_encryption.gif">

Hybrid crypto ecc_blowfish:
<img src="./gifs/blowfish_encryption.gif">




