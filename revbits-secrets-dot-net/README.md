# RevBits PAM Secret Plugin .NET SDK

## Introduction

RevBits PAM secrets manager plugin securely fetches secrets from RevBits PAM.

#### Dependencies:
- Newtonsoft.json

#### NET Framework
- 5.0

## Getting started

### Using Class Library in existing project
Pull git repository

```
gh repo clone RevBits/PAM-SDK
```

Or simply download the RevBits_Secrets class library from ``revbits-secrets-dot-net/Output/RevBits-Secrets.dll``

1. Add reference in you solution:
   - Right click on Your-Solution > Dependencies from solution explorer
   - Click on Add Reference.
   - Select .Net Assembly from tab items.
   - Browse and select the RevBits-Secrets.dll file.


2. Add Newtonsoft dependency:
   - Right click on Your-Solution from solution explorer and select `Manage Nuget Packages`
   - Search and select Newtonsoft.Json package from the list.


3. Complete process by build your project.

### Using in your code

Include Reference to RevBits-Secrets
```cs
using System.RevBits_Secrets;
```

Call Secrets.getSecret function from the code.

```csharp
   // replace this variable with yours.
   string applianceURL = "https://enpast.com";
   string apiKey = "1c3c9e35ebb6a5e197d4bff809b6d3f32590cfca2536d3496526bb0daa9f047213ecbfe61ea32bbb3044f3a11a1da63f8f3b5f67c96a30836c799";
   string secretKey = "secret";
   
   try
   {
       string secret = Secrets.getSecret(applianceURL, secretKey, apiKey).GetAwaiter().GetResult();
       Console.WriteLine(secret);
   }
   catch (APIException e)
   {
       Console.WriteLine("API Exception");
   }
   catch (Exception e)
   {
       Console.WriteLine("Exception");
   }
```



## License

This repository is licensed under Apache License 2.0 - see [`LICENSE`](../LICENSE.md) for more details.
