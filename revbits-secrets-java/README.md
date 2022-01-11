# RevBits PAM Secret Plugin Java SDK

## Introduction

RevBits PAM secrets manager plugin securely fetches secrets from RevBits PAM.

## Getting started

### Using in your project
Pull git repository

```
gh repo clone RevBits/PAM-SDK
```

Or simply download the secretman-sdk from the folder ``revbits-secrets-java/secretman-sdk.aar``

Use following code snippet to use in your code.

```java
try {
    PamAPI.getSecretFromApi("https://server_url_here", "Secret key", "API_KEY_HERE", this);
} catch (Exception e) {
    e.printStackTrace();
}

@Override
public void onSuccess(@NonNull String result) {
    Log.d("PamAPI", "Decrypted success : " + result);

}

@Override
public void onError(@NonNull Throwable throwable) {
    Log.d("PamAPI", "response error : " + throwable.getMessage());

}
```



## License

This repository is licensed under Apache License 2.0 - see [`LICENSE`](../LICENSE.md) for more details.
