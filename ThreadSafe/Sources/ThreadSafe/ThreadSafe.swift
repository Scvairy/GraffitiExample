import Darwin
import Foundation

@attached(peer, names: prefixed(_))
@attached(accessor)
public macro ThreadSafe() = #externalMacro(module: "ThreadSafeMacros", type: "ThreadSafeMacro")
