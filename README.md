# StravaSDK

StravaSDK for iOS http://strava.github.io/api/

本SDK基于[StravaKit 0.9.5](https://github.com/StravaKit/StravaKit/tree/v0.9.5)简单封装和改编而成，支持与OC混编。目前仅支持上传fit活动数据。

> 注：本SDK依赖Alamofire框架，需要在项目中导入`pod 'Alamofire'`



## 配置环境

需要`ClientId`、`ClientSecret`和app的`URLSchemes`

示例代码：

Swift

```swift
StravaSDK.config(clientId: "18583", clientSecret: "a05fde98a830effde2e0f84cc39d76b040d4d67e", appSchemes: "hitfit")
```

Objective-C

```objective-c
[StravaSDK configWithClientId:@"18583" clientSecret:@"a05fde98a830effde2e0f84cc39d76b040d4d67e" appSchemes:@"hitfit"];
```





## 授权

#### 获取授权

Swift

```swift
StravaSDK.authorize()
```
Objective-C
```objective-c
[StravaSDK authorize];
```

#### 取消授权

Swift

```swift
StravaSDK.deauthorize()
```
Objective-C
```objective-c
[StravaSDK deauthorize];
```

#### 查询是否已授权

Swift

```swift
StravaSDK.isAuthorized
```
Objective-C
```objective-c
[StravaSDK isAuthorized];
```



## 上传活动数据（.fit）

Swift

```swift
StravaSDK.uploadActivity(path: ".../test.fit", type: "run", name: "Afternoon Run") { (response, error) in
            
}
```

Objective-C

```objective-c
[StravaSDK uploadActivityWithPath:@".../test.fit" type:@"run" name:@"Afternoon Run" completionHandler:^(id _Nullable response, NSError * _Nullable error) {
    if (error) {
        
    } else {
        
    }
    [self removeTask];
}];
```

