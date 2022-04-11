# B4FSDK
[![CocoaPods](https://img.shields.io/cocoapods/v/B4FSDK)](https://img.shields.io/cocoapods/v/B4FSDK)

[Full Documentation](https://brand4fans.github.io/B4FSDK-iOS)

## Installation
```ruby
target 'MyTarget' do
    pod 'B4FSDK'
end
```

## Usage
#### Set API Key
```swift
B4F.shared.apiKey = "XXXXXXXXXXXX"
```
#### Set user Id
```swift
B4F.shared.userId = "XXXXXXXXXXXX"
```
#### Set push token
```swift
B4F.shared.deviceToken = <Devide Data>
```
#### NFC
```swift
B4F.shared.startNFC(message: "Read a Smarttag")
```
Delegate methods
```swift
func nfcFailWith(error: Error)
func nfcDetectTags(tag: String)
func nfcDidBecomeActive()
```

### Methods
Make sure you have set `B4F.shared.apiKey` and `B4F.shared.userId` before use the following methods.

#### Campaigns
```swift
B4F.shared.campaigns.getMyCampaigns(query: Query?){ result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.campaigns.getAvailableCampaigns(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.campaigns.getFiltersCampaign { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.campaigns.getCampaignBy(id: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.campaigns.subscribeToCampaignWith(id: String, smartTagId: String) { result in
    switch result {
        case .success():
        case .failure(let error):
    }
}
B4F.shared.campaigns.linkAndSubscribeToCampaignWith(id: String, smartTagCode: String) { result in
    switch result {
        case .success():
        case .failure(let error):
    }
}
```
#### Coupons

```swift
B4F.shared.coupons.getCoupons(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.coupons.getUnavailableCoupons(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.coupons.unsubscribeFromCampaignWith(couponId: String) { result in
    switch result {
        case .success():
        case .failure(let error):
    }
}
B4F.shared.coupons.getFiltersCoupon(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.coupons.getCouponBy(id: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.coupons.redeemCouponWith(id: String) { result in
    switch result {
        case .success():
        case .failure(let error):
    }
}
```
#### News
```swift
B4F.shared.news.getNews(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.news.getNewBy(id: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
```

#### Smartags
```swift
B4F.shared.smarttags.getSmartTags(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.smarttags.getSmartTagBy(id: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.smarttags.associateSmartTag(code: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.smarttags.disassociateSmartTag(code: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
```

#### Alerts
```swift
B4F.shared.alerts.getAlerts(query: Query?) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.alerts.getNotReadAlertsCount { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.alerts.setAlertReadBy(id: String) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.alerts.setAllAlertsRead { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
```

#### User
```swift
B4F.shared.user.getUser { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.user.updateUser(user: User) { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
B4F.shared.user.deleteUser { result in
    switch result {
        case .success(let value):
        case .failure(let error):
    }
}
```
