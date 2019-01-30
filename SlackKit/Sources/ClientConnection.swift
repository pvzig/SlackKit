//
//  ClientConnection.swift
//  SlackKit
//
//  Created by Emory Dunn on 12/28/17.
//

import Foundation

public class ClientConnection {
    public var client: Client?
    public var rtm: SKRTMAPI?
    public var webAPI: WebAPI?

    public init(client: Client?, rtm: SKRTMAPI?, webAPI: WebAPI?) {
        self.client = client
        self.rtm = rtm
        self.webAPI = webAPI
    }
}
