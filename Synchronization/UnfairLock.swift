//
//  UnfairLock.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

import Darwin

public struct UnfairLock: ~Copyable {
  private let mutex: UnsafeMutablePointer<os_unfair_lock_s> = .allocate(capacity: 1)

  public init() {
    mutex.initialize(to: os_unfair_lock_s())
  }

  deinit {
    mutex.deinitialize(count: 1)
    mutex.deallocate()
  }
}

public extension UnfairLock {
  func lock() {
    os_unfair_lock_lock(mutex)
  }

  func unlock() {
    os_unfair_lock_unlock(mutex)
  }

  func withLock<T>(_ body: () throws -> T) rethrows -> T {
    lock()
    defer { unlock() }
    return try body()
  }
}
