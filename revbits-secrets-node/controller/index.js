const axios = require('axios');
const AES256 = require('aes-everywhere');
const BigInteger = require('jsbn').BigInteger;
const { getPrivateKey, getPublicKey, getSecret} = require("../utils/encryption");

module.exports = {
    /* ----------------------------------- */
    /* Package Usage */
    /* ----------------------------------- */
    // getSecret('https://enpast.com', 'pamSecretId', 'secretApiKey')
    // Expected output:
    //      {
    //          secret: 'pamSecretValue'
    //      }
    // Exceptions:
    //      {
    //          error: { message: 'No required parameters were found!' }
    //       }
    // ---
    //      {
    //          error: { message: 'Error Message' }
    //       }
    /* ----------------------------------- */

    getSecret: (ApplianceURL, SecretId, apiKey) => {
        try {
            const url = new URL(`/api/v1/secretman/GetSecretV2/${SecretId}`, ApplianceURL);

            const privateKeyA = getPrivateKey();
            const privateKeyB = getPrivateKey();
            const publicKeyA = getPublicKey(privateKeyA);
            const publicKeyB = getPublicKey(privateKeyB);

            return axios.get(url.href, {
                headers: {
                    apiKey,
                    publicKeyA,
                    publicKeyB
                }
            })
                .then((response) => {
                    const {data} = response
                    if (data?.value && data?.keyA && data?.keyB) {
                        // Generate Secrete A and B with keys received from server.
                        const encSecretA = new BigInteger(getSecret(parseInt(data.keyA), privateKeyA).toString());
                        const encSecretB = getSecret(parseInt(data.keyB), privateKeyB);

                        const secret = AES256.decrypt(data.value, encSecretA.pow(encSecretB).toString());

                        return {secret}
                    } else {
                        return {error: {message: 'No required parameters were found!'}}
                    }
                })
                .catch((error) => {
                    return {error}
                })
        } catch (error) {
            return {error: {message: error.message || error.toString()}}
        }
    }
}
