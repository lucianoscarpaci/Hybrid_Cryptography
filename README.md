# 🔐 Hybrid Cryptography

Welcome to the **Hybrid Cryptography** project! This repository showcases a powerful combination of cryptographic algorithms to ensure data security. Dive into the world of encryption with us! 🌐🔒

## 📄 Project Overview

For a detailed architectural description, please refer to the Microsoft Word document **"A hybrid Cryptographic Implementation.docx"** located in the CIS-5371 directory.

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
