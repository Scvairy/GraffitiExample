//
//  StatusCodeTag.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import SCUtils

public enum StatusCodeTag {}
public typealias StatusCode = Tagged<StatusCodeTag, Int>
