<?php

  // Decryption after fetching secrets
  function decrypt($encrypted, $passphrase){
    $encrypted = base64_decode($encrypted);
    $salted = substr($encrypted, 0, 8) == 'Salted__';

    if (!$salted) {
        return null;
    }

    $salt = substr($encrypted, 8, 8);
    $encrypted = substr($encrypted, 16);

    $salted = $dx = '';
    while (strlen($salted) < 48) {
        $dx = md5($dx . $passphrase . $salt, true);
        $salted .= $dx;
    }

    $key = substr($salted, 0, 32);
    $iv = substr($salted, 32, 16);

    return openssl_decrypt($encrypted, 'aes-256-cbc', $key, true, $iv);
}

// Use this function to fetch secrets from RevBits PAM
function generateSecretValue($uri, $secretKey, $apiKey){

    // Preparing URL
    $url  = "{$uri}/api/v1/secretman/GetSecretV2/{$secretKey}";

    // Fixed numbers
    $primeNumber = 23;
    $indexNumber = 9;

    //Generating public keys
    $privKeyA = rand(5,15);
    $privKeyB = rand(5,15);
    $pubKeyA  = (int) fmod(pow($indexNumber, $privKeyA), $primeNumber);
    $pubKeyB  = (int) fmod(pow($indexNumber, $privKeyB), $primeNumber);

    // Preparing Header
    $headers = [
        "apiKey: {$apiKey}",
        "publicKeyA: {$pubKeyA}",
        "publicKeyB: {$pubKeyB}",
        "Accept: application/json",
        "Content-Type: application/json",
        "User-Agent: ENPAST Jenkins Client"
    ];

    // Request to Secret Manager
    $curlHandler = curl_init();
    curl_setopt($curlHandler, CURLOPT_URL, $url);
    curl_setopt($curlHandler, CURLOPT_HEADER, false);
    curl_setopt($curlHandler, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curlHandler, CURLOPT_HTTPHEADER, $headers);
    $output = curl_exec($curlHandler);
    curl_close($curlHandler);
    $data = json_decode($output, true);

    // Generating shared keys
    $sharedKeyA = (int) fmod(pow($data['keyA'], $privKeyA), $primeNumber);
    $sharedKeyB = (int) fmod(pow($data['keyB'], $privKeyB), $primeNumber);

    $finalDecKey = gmp_pow((string)$sharedKeyA, $sharedKeyB);
    $decrypted = decrypt($data['value'], $finalDecKey);

    return $decrypted;
}

