//
//  ThreadSafeStorage.swift
//  GraffitiExample
//
//  Created by Timur Sharifianov on 12.10.2024.
//

public final class ThreadSafeStorage<Value>: @unchecked Sendable {
  private var _wrappedValue: Value
  private let lock = UnfairLock()

  public init(_ wrappedValue: consuming Value) {
    _wrappedValue = wrappedValue
  }
}

public extension ThreadSafeStorage {
  var wrappedValue: Value {
    _read {
      lock.lock()
      defer { lock.unlock() }

      yield _wrappedValue
    }
    _modify {
      lock.lock()
      defer { lock.unlock() }

      yield &_wrappedValue
    }
  }

  /// returns previous value
  @discardableResult
  func update(_ newValue: consuming Value) -> Value {
    lock.lock()
    defer { lock.unlock() }

    swap(&_wrappedValue, &newValue)
    return newValue
  }
}
