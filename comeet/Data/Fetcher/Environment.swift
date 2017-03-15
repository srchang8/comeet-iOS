//
//  Environment.swift
//  comeet
//
//  Created by Ricardo Contreras on 3/14/17.
//  Copyright © 2017 teamawesome. All rights reserved.
//

import Foundation

enum Environment : String {
    case Mocked = "https://private-98f9ba-comeet.apiary-mock.com"
    case Production = "http://ec2-52-35-139-201.us-west-2.compute.amazonaws.com:8080/JavaApplication/rest/UserService"
}
