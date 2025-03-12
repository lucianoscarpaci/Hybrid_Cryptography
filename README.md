# 🔐 Hybrid Cryptography

Welcome to the **Hybrid Cryptography** project! This repository showcases a powerful combination of cryptographic algorithms to ensure data security. Dive into the world of encryption with me. 🌐🔒

## 📄 Project Overview

The project contains a menu to run various hybrid cryptographic algorithms. From this menu, you can choose any of the following: ECC-AES, ECC-Blowfish, AES-RSA, and 3DES-RSA. Each algorithm has its own unique encryption and decryption process, which you can explore through the User Interface. 🛠️🔍


## 🚀 Getting Started

### Prerequisites

Ensure you have all the necessary software packages installed. You can do this by running the following command:

```bash
bundle install
```

### Environment Setup

Create a `.env` file in the CIS-5371 directory with the following environment variables:

- **For ECC:**
  - `ECC_PUBLIC_KEY=`
  - `ECC_PRIVATE_KEY=`

- **For AES:**
  - `AES_KEY=`
  - `AES_IV=`

- **For Triple DES:**
  - `DES_KEY=`

- **For RSA:**
  - `RSA_KEY=`
  - `PUBLIC_KEY=`

## 🛠️ Usage

Once everything is set up, you can run the main program using:

```bash
ruby menu.rb
```

This will launch the User Interface to run all the algorithms. Enjoy exploring the cryptographic techniques! 🔍🔑

## 🎥 Visual Demonstrations

Check out the encryption processes in action:

- **Hybrid crypto 3des_rsa:**
  ![3des_rsa_encryption](./gifs/3des_rsa_encryption.gif)

- **Hybrid crypto aes_rsa:**
  ![aes_rsa_encryption](./gifs/aes_rsa_encryption.gif)

- **Hybrid crypto ecc_aes:**
  ![ecc_aes_encryption](./gifs/ecc_aes_encryption.gif)

- **Hybrid crypto ecc_blowfish:**
  ![blowfish_encryption](./gifs/blowfish_encryption.gif)

## 📬 Contact

For any questions or feedback, feel free to reach out. Let's make cryptography accessible and fun! 🎉🔐

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
