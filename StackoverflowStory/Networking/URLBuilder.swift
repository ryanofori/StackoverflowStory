//
//  URLBuilder.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class URLBuilder {
    //authURL
    let authBaseUrl = "https://stackoverflow.com/oauth/dialog"
     let clientId = "?client_id=17028"
     let scope = "&scope=write_access"
    let privateInfo = ",private_info"
     let redirectUri = "&redirect_uri=https://stackexchange.com/oauth/login_success"
     let key = "&key=tUo34InxiBQXN3La2wI7Bw(("
     let testURl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow"
    let fullUrl = "https://stackoverflow.com/oauth/dialog?client_id=17028&redirect_uri=https://stackexchange.com/oauth/login_success"
     var newAccessToken = "&access_token=" + (CoreDataFetchOps.shared.getAccessToken()?.token ?? "")
     let oauth2PostgetAcceesTokenURL = "https://stackoverflow.com/oauth/dialog?client_id=17028&scope=write_access&redirect_uri=https://stackexchange.com/oauth/login_success"
    
    func authUrlFull() -> String {
        return authBaseUrl + clientId + scope + redirectUri + key + newAccessToken
    }
    
}
