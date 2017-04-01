using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace omnibeat
{
    class CryptoService
    {
        
        public static bool EncryptFile(string inputFile, string outputFile)
        {
        	CryptoStream cs = null;
        	FileStream fsCrypt = null, fsIn = null;
        	RijndaelManaged RMCrypto;
        	
            try
            {
                string password = @"myKey123"; 
                UnicodeEncoding UE = new UnicodeEncoding();
                byte[] key = UE.GetBytes(password);

                string cryptFile = outputFile;
                fsCrypt = new FileStream(cryptFile, FileMode.Create);

                RMCrypto = new RijndaelManaged();

                cs = new CryptoStream(fsCrypt, RMCrypto.CreateEncryptor(key, key), CryptoStreamMode.Write);

                fsIn = new FileStream(inputFile, FileMode.Open);

                int data;
                while ((data = fsIn.ReadByte()) != -1)
                    cs.WriteByte((byte)data);

                return true;
            }
            catch (Exception exc)
            {
                EventLog.WriteEntry("ProteusRadioSource", "Encryption failed! = " + exc.Message);
                return false;
            }
            finally 
            {
                if(fsIn!=null)
                    fsIn.Close();
                if(cs!=null)
                    cs.Close();
                if(fsCrypt!=null)
                    fsCrypt.Close();
            }
        }

        public static bool DecryptFile(string inputFile, string outputFile)
        {
        	CryptoStream cs = null;
        	FileStream fsCrypt = null, fsOut = null;
        	RijndaelManaged RMCrypto;
            try
            {
                string password = @"myKey123"; // Your Key Here

                UnicodeEncoding UE = new UnicodeEncoding();
                byte[] key = UE.GetBytes(password);

                fsCrypt = new FileStream(inputFile, FileMode.Open);

                RMCrypto = new RijndaelManaged();

                cs = new CryptoStream(fsCrypt, RMCrypto.CreateDecryptor(key, key), CryptoStreamMode.Read);

                fsOut = new FileStream(outputFile, FileMode.Create);

                int data;
                while ((data = cs.ReadByte()) != -1)
                    fsOut.WriteByte((byte)data);

                return true;

            }
            catch(Exception exc)
            {
                EventLog.WriteEntry("ProteusRadioSource", "Exception Decrypting file "+ exc);
                return false;
            }
            finally
            {
                if(fsOut != null)  
                	fsOut.Close();
                if(cs != null) 
                	cs.Close();
                if(fsCrypt != null) 
                	fsCrypt.Close();
            }
        }
    }
}