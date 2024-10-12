import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct ThreadSafePlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    ThreadSafeMacro.self,
  ]
}

public struct ThreadSafeMacro {
  let variableDeclSyntax: VariableDeclSyntax
  let binding: PatternBindingSyntax
  let name: IdentifierPatternSyntax

  var storagePropertyName: TokenSyntax {
    .identifier("_" + name.identifier.text)
  }

  init(decl: some DeclSyntaxProtocol) throws {
    guard let syntax = decl.as(VariableDeclSyntax.self) else {
      throw ThreadSafeMacroError.declarationIsNotVariable
    }

    guard let binding = syntax.bindings.first,
          let pattern = binding.pattern.as(IdentifierPatternSyntax.self)
    else {
      throw ThreadSafeMacroError.notSupportedYetSyntax
    }

    variableDeclSyntax = syntax
    self.binding = binding
    name = pattern
  }

  var accessors: [AccessorDeclSyntax] {
    let read: AccessorDeclSyntax = """
    _read {
        yield \(storagePropertyName).wrappedValue
    }
    """

    let modify: AccessorDeclSyntax = """
    _modify {
        yield &\(storagePropertyName).wrappedValue
    }
    """

    return [read, modify]
  }

  func storage() throws -> DeclSyntax {
    guard let typeAnnotation = binding.typeAnnotation,
          let initializer = binding.initializer
    else {
      throw ThreadSafeMacroError.notSupportedYetSyntax
    }

    var type = typeAnnotation.type
    type.leadingTrivia = []
    type.trailingTrivia = []

    let value = FunctionCallExprSyntax(
      calledExpression: GenericSpecializationExprSyntax(
        expression: DeclReferenceExprSyntax(baseName: .identifier("ThreadSafeStorage")),
        genericArgumentClause: GenericArgumentClauseSyntax {
          GenericArgumentSyntax(argument: type)
        }
      ),
      leftParen: .leftParenToken(),
      arguments: LabeledExprListSyntax {
        LabeledExprSyntax(expression: initializer.value)
      },
      rightParen: .rightParenToken()
    )

    let result = VariableDeclSyntax(
      modifiers: DeclModifierListSyntax {
        DeclModifierSyntax(name: .keyword(.private))
      },
      bindingSpecifier: .keyword(.let),
      bindingsBuilder: {
        PatternBindingSyntax(
          pattern: IdentifierPatternSyntax(identifier: storagePropertyName),
          initializer: InitializerClauseSyntax(value: value)
        )
      },
      trailingTrivia: nil
    )

    return DeclSyntax(result)
  }
}

extension ThreadSafeMacro: PeerMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingPeersOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    try [ThreadSafeMacro(decl: declaration).storage()]
  }
}

extension ThreadSafeMacro: AccessorMacro {
  public static func expansion(
    of node: AttributeSyntax,
    providingAccessorsOf declaration: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AccessorDeclSyntax] {
    try ThreadSafeMacro(decl: declaration).accessors
  }
}

enum ThreadSafeMacroError: Error {
  case declarationIsNotVariable
  case notSupportedYetSyntax
}
