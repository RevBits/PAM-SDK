using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace RevBits_Secrets
{
    public class APIException : Exception
    {
        public APIException(string message) : base(message)
        {
        }
    }
    public class Secrets
    {
        static readonly HttpClient client = new HttpClient();
        static readonly Crypto crypto = new Crypto();

        // Necessary attributes for decryption 
        static long keyA = 0;
        static long keyB = 0;

        static long sharedKeyA = 0;
        static long sharedKeyB = 0;

        const long prime = 23;
        const long generated = 9;

        static long privateKeyA = (long)Math.Round((double)new Random().NextDouble() * 8 + 2);
        static long privateKeyB = (long)Math.Round((double)new Random().NextDouble() * 8 + 2);
        static long publicKeyA = (long)Math.Round(Math.Pow(generated, privateKeyA) % prime);
        static long publicKeyB = (long)Math.Round(Math.Pow(generated, privateKeyB) % prime);

        class Secret
        {
            public string value { get; set; }
            public long keyA { get; set; }
            public long keyB { get; set; }
            public string errorMessage { get; set; }
        }

        /// <summary>
        /// Receives encrypted secret from PAM and decrypts it in usable form
        /// </summary>
        /// <param name="ApplianceURL">PAM Appliance URL e.g. https://www.enpast.com</param>
        /// <param name="SecretId">Secret ID received from PAM</param>
        /// <param name="APIKey">API Key generated from PAM</param>
        public static async Task<string> getSecret(string ApplianceURL, string SecretId, string APIKey)
        {
            var address = new UriBuilder(ApplianceURL + "/api/v1/secretman/GetSecretV2/" + SecretId);
            string secret = "";

            client.DefaultRequestHeaders.Add("apiKey", APIKey);
            client.DefaultRequestHeaders.Add("publicKeyA", publicKeyA.ToString());
            client.DefaultRequestHeaders.Add("publicKeyB", publicKeyB.ToString());
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("text/json"));

            HttpResponseMessage response = await client.GetAsync(address.Uri);

            var resp = await response.Content.ReadAsStringAsync();

            Secret j = JsonConvert.DeserializeObject<Secret>(resp);

            if (j.errorMessage != "" && j.errorMessage != null)
            {
                throw (new APIException(j.errorMessage));
            }

            if (j.value != "" && j.value != null)
            {
                keyA = j.keyA;
                keyB = j.keyB;

                sharedKeyA = (long)Math.Pow(keyA, privateKeyA) % prime;
                sharedKeyB = (long)Math.Pow(keyB, privateKeyB) % prime;

                Int64 bSharedKeyA = sharedKeyA;
                Int64 bSharedKeyB = sharedKeyB;
                Int64 finalSecret = (long)Math.Pow(bSharedKeyA, bSharedKeyB);

                secret = crypto.Decrypt(j.value, finalSecret.ToString());
            }

            return secret;
        }
    }
}
