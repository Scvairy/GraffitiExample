//
//  RequestStatus.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//
import Foundation

typealias RequestStatus<Request> = Loadable<URLSession.HTTPError, Request>
