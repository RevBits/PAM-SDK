# RevBits PAM Secret Plugin Node SDK

## Introduction

RevBits PAM secrets manager plugin securely fetches secrets from RevBits PAM.

## Getting started

Pull git repository

```
git clone git@www.revbits.co:ENPAST-SRV/pam-credentials-plugin.git
```

More into directory
```
cd revbits-secrets-sdk-node
```

Install dependencies
```
npm i
```

### Running Demo/Test

```
npm run test
```

### Using in your code

```node
const getSecret = require('revbits-secrets-node')

// replace values with yours
const ApplianceURL = 'https://enpast.com';
const secretId = 'pamSecretId';
const apiKey = 'apiKeyReceivedFromPam'

const sec = await getSecret(ApplianceURL, secretId, apiKey)

// expected output
{
    value: 'your secret from pam'
}
```


## License

This repository is licensed under Apache License 2.0 - see [`LICENSE`](../LICENSE.md) for more details.
