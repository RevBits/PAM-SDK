# RevBits PAM Secret Plugin PHP SDK

## Introduction

RevBits PAM secrets manager plugin securely fetches secrets from RevBits PAM.

## Getting started

### Using in your project
Pull git repository

```
gh repo clone RevBits/PAM-SDK
```

Or simply download the PHP file from the folder ``revbits-secrets-php/secrets.php``

Use following code snippet to use in your code.

Include header file
```php
include 'secrets.php';
```
Use this function to fetch secrets
```php
// replace these variable with yours
$applianceURL = "https://enpast.com";
$secretKey = "pamSecretKey";
$apiKey = "1c3c9e35ebb6a5e197d4bff809b6d3f32590cfca2536d3496526bb0daa9f047213ecbfe61ea32bbb3044f3a11a1da63f8f3b5f67c96a30836c799";

$secret = generateSecretValue($applianceURL, $secretKey, $apiKey);
```



## License

This repository is licensed under Apache License 2.0 - see [`LICENSE`](../LICENSE.md) for more details.
