using System;
using System.Security.Cryptography;
using System.IO;
using System.Text;

namespace RevBits_Secrets
{
    class Crypto
    {
        private const int BlockSize = 16;
        private const int KeyLen = 32;
        private const int IvLen = 16;

        private byte[] key;
        private byte[] iv;

        /// <summary>
        /// Derypt encrypted text with the password using random salt.
        /// Returns the decrypted string.
        /// </summary>
        /// <param name="encrypted">Encrypted text to decrypt</param>
        /// <param name="passphrase">Passphrase</param>
        public string Decrypt(string encrypted, string passphrase)
        {
            return Encoding.UTF8.GetString(DecryptToBytes(encrypted, passphrase));
        }

        private byte[] DecryptToBytes(string encrypted, string passphrase)
        {
            byte[] ct = Convert.FromBase64String(encrypted);
            if (ct == null || ct.Length <= 0)
            {
                return new byte[0];
            }

            byte[] salted = new byte[8];
            Array.Copy(ct, 0, salted, 0, 8);

            if (Encoding.UTF8.GetString(salted) != "Salted__")
            {
                return new byte[0];
            }

            byte[] salt = new byte[8];
            Array.Copy(ct, 8, salt, 0, 8);

            byte[] cipherText = new byte[ct.Length - 16];
            Array.Copy(ct, 16, cipherText, 0, ct.Length - 16);

            DeriveKeyAndIv(passphrase, salt);

            byte[] decrypted;
            using (var aes = new RijndaelManaged())
            {
                aes.BlockSize = BlockSize * 8;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;
                aes.Key = key;
                aes.IV = iv;
                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);
                using (var msDecrypt = new MemoryStream())
                {
                    using (var csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Write))
                    {
                        csDecrypt.Write(cipherText, 0, cipherText.Length);
                        csDecrypt.FlushFinalBlock();
                        decrypted = msDecrypt.ToArray();
                    }
                }
            }

            return decrypted;
        }

        private void DeriveKeyAndIv(string passphrase, byte[] salt)
        {
            MD5 md5 = MD5.Create();

            key = new byte[KeyLen];
            iv = new byte[IvLen];

            byte[] dx = new byte[] { };
            byte[] salted = new byte[] { };
            byte[] pass = Encoding.UTF8.GetBytes(passphrase);

            for (int i = 0; i < (KeyLen + IvLen / 16); i++)
            {
                dx = Concat(Concat(dx, pass), salt);
                dx = md5.ComputeHash(dx);
                salted = Concat(salted, dx);
            }

            Array.Copy(salted, 0, key, 0, KeyLen);
            Array.Copy(salted, KeyLen, iv, 0, IvLen);
        }

        private static byte[] Concat(byte[] a, byte[] b)
        {
            byte[] output = new byte[a.Length + b.Length];

            for (int i = 0; i < a.Length; i++)
                output[i] = a[i];
            for (int j = 0; j < b.Length; j++)
                output[a.Length + j] = b[j];

            return output;
        }
    }
}