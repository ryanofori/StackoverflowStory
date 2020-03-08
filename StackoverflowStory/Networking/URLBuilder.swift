//
//  URLBuilder.swift
//  StackoverflowStory
//
//  Created by Ryan Ofori on 3/5/20.
//  Copyright © 2020 Ryan Ofori. All rights reserved.
//

import UIKit

struct URLBuilder {
    static let authBaseUrl = "https://stackoverflow.com/oauth/dialog"
    static let clientId = "?client_id=17028"
    static let scope = "&scope=write_access"
    static let redirectUri = "&redirect_uri=https://stackexchange.com/oauth/login_success"
    static let key = "&key=tUo34InxiBQXN3La2wI7Bw(("
    static let authUrlFull = URLBuilder.authBaseUrl + URLBuilder.clientId + URLBuilder.scope + URLBuilder.redirectUri + URLBuilder.key + Token.token
    static let testURl = "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow"
        static let fullUrl = "https://stackoverflow.com/oauth/dialog?client_id=17028&redirect_uri=https://stackexchange.com/oauth/login_success"
    static var newAccessToken = "&access_token=" + (CoreDataFetchOps.shared.getAccessToken()?.token ?? "")
    static let oauth2PostgetAcceesTokenURL = "https://stackoverflow.com/oauth/dialog?client_id=17028&scope=write_access&redirect_uri=https://stackexchange.com/oauth/login_success"
}
