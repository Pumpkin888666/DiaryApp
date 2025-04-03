# DiaryApp

Open source, open, free, and secure
Record your every day.

##Change the default settings of the app

###Configuration file

1. **`models/app_ini.dart`**
-ApiURL: API interface address.

2. **`funcs/requestApi.dart`**
-`'apiKey `: API key.
-The corresponding server-side configuration in the database:` app_settings -> api_key`。

###Precautions
Please be careful and avoid using untrusted API interfaces, otherwise your data may be leaked.

##Package App

Execute the following command to package:

```bash
flutter build windows
