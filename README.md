# DiaryApp

开源、开放、免费、安全  
记录你的每一天。

## 更改 APP 默认设置

### 配置文件

1. **`models/app_ini.dart`**
    - `apiUrl`：API 接口地址。

2. **`funcs/requestApi.dart`**
    - `_apiKey`：API 密钥。
    - 对应的 Server 端在数据库中的配置：`app_settings -> api_key`。

### 注意事项
请务必小心，避免使用不信任的 API 接口，否则你的数据可能会泄露。

## 打包 App

执行以下命令进行打包：

```bash
flutter build windows
