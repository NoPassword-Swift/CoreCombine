//
//  NamedCurrentValueSubject.swift
//  CoreCombine
//

import Combine

final public class NamedCurrentValueSubject<Output, Failure> where Failure: Error {
	public let name: String
	private let subject: CurrentValueSubject<Output, Failure>

	public var value: Output { self.subject.value }

	public init(name: String, _ value: Output) {
		self.name = name
		self.subject = CurrentValueSubject(value)
	}
}

extension NamedCurrentValueSubject: Publisher {
	public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
		self.subject.receive(subscriber: subscriber)
	}
}

extension NamedCurrentValueSubject: Subject {
	public func send(_ value: Output) {
		self.subject.send(value)
	}

	public func send(completion: Subscribers.Completion<Failure>) {
		self.subject.send(completion: completion)
	}

	public func send(subscription: Subscription) {
		self.subject.send(subscription: subscription)
	}
}
