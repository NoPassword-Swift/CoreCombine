//
//  CurrentValuePublisher.swift
//  CoreCombine
//

import Combine

public protocol CurrentValuePublisher: Publisher {
	var value: Output { get }
}

extension CurrentValueSubject: CurrentValuePublisher {}
extension NamedCurrentValueSubject: CurrentValuePublisher {}
