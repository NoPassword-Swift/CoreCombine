//
//  AnyFailureSubject.swift
//  CoreCombine
//

import Combine

@frozen
public enum AnyFailureCompletion {
	/// The publisher finished normally.
	case finished

	/// The publisher stopped publishing due to the indicated error.
	case failure
}

public final class AnyFailureSubject<Output> {
	private let subject: Any

	private let sendClosure: (Output) -> Void
	private let sinkClosure: (@escaping (AnyFailureCompletion) -> Void, @escaping (Output) -> Void) -> AnyCancellable

	public init<S: Subject>(subject: S) where S.Output == Output {
		self.subject = subject
		self.sendClosure = subject.send
		self.sinkClosure = { receiveCompletion, receiveValue in
			subject.sink(receiveCompletion: {
				switch $0 {
					case .finished: receiveCompletion(.finished)
					case .failure: receiveCompletion(.failure)
				}
			}, receiveValue: receiveValue)
		}
	}

	public func send(_ value: Output) {
		self.sendClosure(value)
	}

	public func sink(receiveCompletion: @escaping (AnyFailureCompletion) -> Void, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
		self.sinkClosure(receiveCompletion, receiveValue)
	}
}

public extension Subject {
	func asAnyFailure() -> AnyFailureSubject<Output> {
		AnyFailureSubject(subject: self)
	}
}
