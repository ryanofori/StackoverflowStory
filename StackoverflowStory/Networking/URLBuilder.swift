//
//  URLBuilder.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

class URLBuilder {
    let authBaseUrl = "https://stackoverflow.com/oauth/dialog"
    let clientId = "?client_id=17028"
    let scope = "&scope=write_access,private_info"
    let redirectUri = "&redirect_uri=https://stackexchange.com/oauth/login_success"
    let baseUrl = "https://api.stackexchange.com/2.2/"
    
    let key = "&key=tUo34InxiBQXN3La2wI7Bw(("
    var sort = "&sort=activity"
    let filter = "&filter=!FnhX5sXiIrG3hI*4CNkiuWygeb"
    var newAccessToken = "&access_token=" + (CoreDataFetchOps.shared.getAccessToken()?.token ?? "")
    let site = "&site=stackoverflow.com"
    let oauth2PostgetAcceesTokenURL = "https://stackoverflow.com/oauth/dialog?client_id=17028&scope=write_access,private_info&redirect_uri=https://stackexchange.com/oauth/login_success"
    
    func authUrlFull() -> String {
        return authBaseUrl + clientId + scope + redirectUri + key + newAccessToken
    }
    //    func oauth2PostgetAcceesTokenURL() -> String {
    //        return authBaseUrl + clientId + scope + redirectUri
    //    }
    
}
