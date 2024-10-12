@dynamicMemberLookup
public struct Tagged<Tag, RawValue: Sendable>: Sendable {
  public var rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public func map<B>(_ f: (RawValue) -> B) -> Tagged<Tag, B> {
    Tagged<Tag, B>(rawValue: f(self.rawValue))
  }
}

public extension Tagged {
  subscript<T>(dynamicMember keyPath: KeyPath<RawValue, T>) -> T {
    self.rawValue[keyPath: keyPath]
  }
}

extension Tagged: CustomStringConvertible {
  public var description: String {
    String(describing: self.rawValue)
  }
}

extension Tagged: RawRepresentable {}

extension Tagged: CustomPlaygroundDisplayConvertible {
  public var playgroundDescription: Any {
    self.rawValue
  }
}

// MARK: - Conditional Conformances

extension Tagged: Collection where RawValue: Collection {
  public typealias Element = RawValue.Element
  public typealias Index = RawValue.Index

  public func index(after i: RawValue.Index) -> RawValue.Index {
    rawValue.index(after: i)
  }

  public subscript(position: RawValue.Index) -> RawValue.Element {
    rawValue[position]
  }

  public var startIndex: RawValue.Index {
    rawValue.startIndex
  }

  public var endIndex: RawValue.Index {
    rawValue.endIndex
  }

  public __consuming func makeIterator() -> RawValue.Iterator {
    rawValue.makeIterator()
  }
}

extension Tagged: Comparable where RawValue: Comparable {
  public static func < (lhs: Tagged, rhs: Tagged) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}

extension Tagged: Decodable where RawValue: Decodable {
  public init(from decoder: Decoder) throws {
    do {
      try self.init(rawValue: decoder.singleValueContainer().decode(RawValue.self))
    } catch {
      try self.init(rawValue: RawValue(from: decoder))
    }
  }
}

extension Tagged: Encodable where RawValue: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

extension Tagged: Equatable where RawValue: Equatable {}

extension Tagged: Error where RawValue: Error {}

#if canImport(Foundation)
import Foundation

extension Tagged: LocalizedError where RawValue: Error {
  public var errorDescription: String? {
    rawValue.localizedDescription
  }

  public var failureReason: String? {
    (rawValue as? LocalizedError)?.failureReason
  }

  public var helpAnchor: String? {
    (rawValue as? LocalizedError)?.helpAnchor
  }

  public var recoverySuggestion: String? {
    (rawValue as? LocalizedError)?.recoverySuggestion
  }
}
#endif

extension Tagged: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral {
  public typealias BooleanLiteralType = RawValue.BooleanLiteralType

  public init(booleanLiteral value: RawValue.BooleanLiteralType) {
    self.init(rawValue: RawValue(booleanLiteral: value))
  }
}

extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral
  where RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
  public typealias ExtendedGraphemeClusterLiteralType = RawValue.ExtendedGraphemeClusterLiteralType

  public init(extendedGraphemeClusterLiteral: ExtendedGraphemeClusterLiteralType) {
    self.init(rawValue: RawValue(extendedGraphemeClusterLiteral: extendedGraphemeClusterLiteral))
  }
}

extension Tagged: ExpressibleByFloatLiteral where RawValue: ExpressibleByFloatLiteral {
  public typealias FloatLiteralType = RawValue.FloatLiteralType

  public init(floatLiteral: FloatLiteralType) {
    self.init(rawValue: RawValue(floatLiteral: floatLiteral))
  }
}

extension Tagged: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
  public typealias IntegerLiteralType = RawValue.IntegerLiteralType

  public init(integerLiteral: IntegerLiteralType) {
    self.init(rawValue: RawValue(integerLiteral: integerLiteral))
  }
}

extension Tagged: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral {
  public typealias StringLiteralType = RawValue.StringLiteralType

  public init(stringLiteral: StringLiteralType) {
    self.init(rawValue: RawValue(stringLiteral: stringLiteral))
  }
}

extension Tagged: ExpressibleByStringInterpolation where RawValue: ExpressibleByStringInterpolation {
  public typealias StringInterpolation = RawValue.StringInterpolation

  public init(stringInterpolation: Self.StringInterpolation) {
    self.init(rawValue: RawValue(stringInterpolation: stringInterpolation))
  }
}

extension Tagged: ExpressibleByUnicodeScalarLiteral where RawValue: ExpressibleByUnicodeScalarLiteral {
  public typealias UnicodeScalarLiteralType = RawValue.UnicodeScalarLiteralType

  public init(unicodeScalarLiteral: UnicodeScalarLiteralType) {
    self.init(rawValue: RawValue(unicodeScalarLiteral: unicodeScalarLiteral))
  }
}

extension Tagged: Identifiable where RawValue: Identifiable {
  public typealias ID = RawValue.ID

  public var id: ID {
    rawValue.id
  }
}

extension Tagged: LosslessStringConvertible where RawValue: LosslessStringConvertible {
  public init?(_ description: String) {
    guard let rawValue = RawValue(description) else { return nil }
    self.init(rawValue: rawValue)
  }
}

extension Tagged: AdditiveArithmetic where RawValue: AdditiveArithmetic {
  public static var zero: Tagged {
    self.init(rawValue: .zero)
  }

  public static func + (lhs: Tagged, rhs: Tagged) -> Tagged {
    self.init(rawValue: lhs.rawValue + rhs.rawValue)
  }

  public static func += (lhs: inout Tagged, rhs: Tagged) {
    lhs.rawValue += rhs.rawValue
  }

  public static func - (lhs: Tagged, rhs: Tagged) -> Tagged {
    self.init(rawValue: lhs.rawValue - rhs.rawValue)
  }

  public static func -= (lhs: inout Tagged, rhs: Tagged) {
    lhs.rawValue -= rhs.rawValue
  }
}

extension Tagged: Numeric where RawValue: Numeric {
  public init?(exactly source: some BinaryInteger) {
    guard let rawValue = RawValue(exactly: source) else { return nil }
    self.init(rawValue: rawValue)
  }

  public var magnitude: RawValue.Magnitude {
    rawValue.magnitude
  }

  public static func * (lhs: Tagged, rhs: Tagged) -> Tagged {
    self.init(rawValue: lhs.rawValue * rhs.rawValue)
  }

  public static func *= (lhs: inout Tagged, rhs: Tagged) {
    lhs.rawValue *= rhs.rawValue
  }
}

extension Tagged: Hashable where RawValue: Hashable {}

extension Tagged: SignedNumeric where RawValue: SignedNumeric {}

extension Tagged: Sequence where RawValue: Sequence {
  public typealias Iterator = RawValue.Iterator

  public __consuming func makeIterator() -> RawValue.Iterator {
    rawValue.makeIterator()
  }
}

// MARK: - Coerce

public extension Tagged {
  func coerced<Tag2>(to _: Tag2.Type) -> Tagged<Tag2, RawValue> {
    unsafeBitCast(self, to: Tagged<Tag2, RawValue>.self)
  }
}
