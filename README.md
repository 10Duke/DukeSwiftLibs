# DukeSwiftLibs

[![Version](https://img.shields.io/cocoapods/v/DukeSwiftLibs.svg?style=flat)](http://cocoapods.org/pods/DukeSwiftLibs)
[![License](https://img.shields.io/cocoapods/l/DukeSwiftLibs.svg?style=flat)](http://cocoapods.org/pods/DukeSwiftLibs)
[![Platform](https://img.shields.io/cocoapods/p/DukeSwiftLibs.svg?style=flat)](http://cocoapods.org/pods/DukeSwiftLibs)


## Overview

A library set of tools to ease the iOS mobile development of the 10Duke SSO and REST API functionality. An example application is included that illustrates the use of the provided APIs.

## Example

To run the example IdP SSO and REST API using project, clone the repo, and run `pod install` from the Example directory first.

The example application connects the user to a running instance of the IdP service.
 
####Example application features:
* SSO login
* SSO logout
* Logged in user page for modification
* User listing, viewing, updating, creation and deletion
* Role listing, viewing, updating, creation and deletion
* Group listing, viewing, updating, creation and deletion
* Organization listing, viewing, updating, creation and deletion

## Client / API configuration

####Duke API configuration

The configuration can be done once i.e. within the AppDelegate class during app startup.

```swift
// Get the singleton instance of the ApiConfig
let apiConfig = ApiConfigImpl.shared
apiConfig.setIdPBaseUrl("http://vslidp.10duke.com/")
apiConfig.setSSOClientId("ios_test")
apiConfig.setSSORedirectUrl("tendukeauthapp://oauth/callback")
```

* In the sample app a ClientConfig class provides values for the configuration.
* The given SSO client id and redirect url values need to be correspondingly configured on the serverside.

## Sample code for SSO login and logout

### SSO login and logout

```swift
// Get the singleton of the SSO
let sso = SSOImpl.shared
//
// Check if user is currently logged in to provide right action
if let sso.isUserLoggedIn() {
    // Logout
    sso.logout(controller: self.navigationController!)
} else {
    // Login
    sso.login(controller: self.navigationController!)
}
```

A successful login will store the OAuth2 Bearer token to the ApiTokenImpl singleton. See the example application for a reference implementation.

```swift
// Get the singleton of ApiToken
let apiToken = ApiTokenImpl.shared
//
let userId = apiToken.getUserId()
//
let token = apiToken.getToken()
```

### ApiToken and Bearer token usage 

The Oauth2 Bearer token can be used in HTTP requests i.e. towards the REST API in the authentication haeder.
 
```swift
let webConfiguration = WKWebViewConfiguration()
webConfiguration.processPool = SSOImpl.shared.getProcessPool()
//
let webView = WKWebView(frame: .zero, configuration: webConfiguration)
webView.navigationDelegate = self
//
let token = apiToken.getToken()
let requestUrl = URL(string: "http://www.example.com/")
var request = URLRequest(url: requestUrl)
//
if token != nil {
    //
    request.setValue("Bearer \(m_token)", forHTTPHeaderField: "Authorization")
}
//
webView.load(request)
```

* The included WKWebViewController.swift class in the DukeSwiftLibs is a working example of a webview that uses the token as above.
* The RestApiImpl.swift class has an example implementation on how Alamofire cookies can be set to contain the bearer token.
* The process pool from SSOImpl.swift class provides a mechanism for sharing cookies in between webviews.


## Example REST API usage

### User object CRUD operations examples

Here is a list of sample code, similar to which can be found in the provided sample app that demonstrates the use of the REST API.

#### REST API example: Create User

```swift
// Get the singleton of the REST API
let restApi = RestApiImpl.shared
//
// User "CREATE" request
restApi.createUser(user, completion: createCallback(_:))
//
// User "CREATE" callback
func createCallback(_ success: Bool) {
    //
    if success {
        //
        m_createButton?.isEnabled = false
    } else {
        //
        showError(title: "User create failed", message: "Press Ok to continue.")
    }
}
```

#### REST API example: Read User

Pushes the 10Duke storyboard UserViewController to the UI in case user is returned from the API.

```swift
// Get the singleton of the REST API
let restApi = RestApiImpl.shared
//
// Get the singleton of the api token
let apiToken = ApiTokenImpl.shared
//
if let userId = apiToken.getUserId() {
    //
    restApi.getUser(id: id, completion: getUserCallback(_:))
    //
    // User "READ" callback
    func userCallback(_ user: User?) {
        //
        if let myUser = user {
            //
            let storyboard = UIStoryboard(name: "10Duke", bundle: nil)
            let userViewController = storyboard.instantiateViewController(withIdentifier: "UserViewController") as! UserViewController
            userViewController.m_user = myUser
            self.navigationController?.pushViewController(userViewController, animated: true)
        } else {
            //
            showError(title: "User read failed", message: "Press Ok to continue.")
        }
    }
}
```

#### REST API example: Update User

```swift
// Get the singleton of the REST API
let restApi = RestApiImpl.shared
//
let user = <your-user-object-here>
//
// User "UPDATE" request
restApi.updateUser(user, completion: updateCallback(_:))
//
// User "UPDATE" callback
func updateCallback(_ success: Bool) {
    //
    if success {
        //
        // Disables update action clickable button visible on screen.
        m_updateButton?.isEnabled = false
    } else {
        //
        showError(title: "User update failed", message: "Press Ok to continue.")
    }
}
```

#### REST API example: Delete User

```swift
// Get the singleton of the REST API
let restApi = RestApiImpl.shared
//
let user = <your-user-object-here>
//
// User "DELETE" request
restApi.deleteUser(user, completion: deleteCallback(_:))
//
// User "DELETE" callback
func deleteCallback(_ success: Bool) {
    //
    if success {
        //
        // Disables delete action clickable button visible on screen.
        m_deleteButton?.isEnabled = false
    } else {
        //
        showError(title: "User delete failed", message: "Press Ok to continue.")
    }
}
```

## Requirements

The Swift 3 implementation has a platform target iOS 10.0.

The following CocoaPods are used as internal dependencies in the library implementation:
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [EVReflection](https://github.com/evermeer/EVReflection/)
* [JWTDecode](https://github.com/auth0/JWTDecode.swift)
* [Locksmith](https://github.com/matthewpalmer/Locksmith)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

## Installation

DukeSwiftLibs is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "DukeSwiftLibs"
```

After installing the pod using:
```swift
pod install
```

You can use the DukeSwiftLibs as an import in your .swift files:
```swift
import DukeSwiftLibs
```

## Author

Antti Tohmo, antti.tohmo@10duke.com

## License

DukeSwiftLibs is available under the MIT license. See the LICENSE file for more info.
