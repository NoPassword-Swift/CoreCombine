//
//  CBUserDefaults.swift
//  CoreCombine
//

import Combine
import Foundation

public class CBUserDefaults {
	public let name: String
	public let defaults: UserDefaults
	private var subscriptions = [AnyCancellable]()

	private var boolSubjects = [String : (subject: CBSubject<Bool>, default: Bool)]()
	private var stringSubjects = [String : (subject: CBSubject<String>, default: String)]()
	private var doubleSubjects = [String : (subject: CBSubject<Double>, default: Double)]()
	private var dateSubjects = [String : (subject: CBSubject<Date>, default: Date)]()
	private var arraySubjects = [String : (subject: CBSubject<Array<Any>>, default: Array<Any>)]()

	public init(name: String, from defaults: UserDefaults) {
		self.name = name
		self.defaults = defaults
	}

	public var keys: Dictionary<String, Any>.Keys {
		self.defaults.dictionaryRepresentation().keys
	}
	public var alphabeticallySortedKeys: [String] {
		self.defaults.dictionaryRepresentation().keys.sorted { $0.lowercased() < $1.lowercased() }
	}
	public var lexicographicallySortedKeys: [String] {
		self.defaults.dictionaryRepresentation().keys.sorted { $0.lexicographicallyPrecedes($1) }
	}

	public func delete(key: String) {
		if let value = self.boolSubjects[key] {
			value.subject.send(value.default)
			self.defaults.set(nil, forKey: key)
		}
		if let value = self.stringSubjects[key] {
			value.subject.send(value.default)
			self.defaults.set(nil, forKey: key)
		}
	}

	public func boolSubject(forKey key: String, default: Bool = false) -> CBSubject<Bool> {
		if let value = self.boolSubjects[key] {
			return value.subject
		}
		let subject = CBSubject(name: key, self.defaults.value(forKey: key) as? Bool ?? `default`)
		subject.sink { self.defaults.set($0, forKey: key) }.store(in: &self.subscriptions)
		self.boolSubjects[key] = (subject, `default`)
		return subject
	}

	public func stringSubject(forKey key: String, default: String = "") -> CBSubject<String> {
		if let value = self.stringSubjects[key] {
			return value.subject
		}
		let subject = CBSubject(name: key, self.defaults.value(forKey: key) as? String ?? `default`)
		subject.sink { self.defaults.set($0, forKey: key) }.store(in: &self.subscriptions)
		self.stringSubjects[key] = (subject, `default`)
		return subject
	}

	public func doubleSubject(forKey key: String, default: Double = 0) -> CBSubject<Double> {
		if let value = self.doubleSubjects[key] {
			return value.subject
		}
		let subject = CBSubject(name: key, self.defaults.value(forKey: key) as? Double ?? `default`)
		subject.sink { self.defaults.set($0, forKey: key) }.store(in: &self.subscriptions)
		self.doubleSubjects[key] = (subject, `default`)
		return subject
	}

	public func dateSubject(forKey key: String, default: Date = Date()) -> CBSubject<Date> {
		if let value = self.dateSubjects[key] {
			return value.subject
		}
		let subject = CBSubject(name: key, self.defaults.value(forKey: key) as? Date ?? `default`)
		subject.sink { self.defaults.set($0, forKey: key) }.store(in: &self.subscriptions)
		self.dateSubjects[key] = (subject, `default`)
		return subject
	}

	public func arraySubject(forKey key: String, default: Array<Any> = []) -> CBSubject<Array<Any>> {
		if let value = self.arraySubjects[key] {
			return value.subject
		}
		let subject = CBSubject(name: key, self.defaults.value(forKey: key) as? Array<Any> ?? `default`)
		subject.sink { self.defaults.set($0, forKey: key) }.store(in: &self.subscriptions)
		self.arraySubjects[key] = (subject, `default`)
		return subject
	}

	/// Uses a `stringSubject` as the backing for a `CBSubject<T>`.
	/// Do not call this multiple times with the same key.
	public func registerSubject<T>(forKey key: String, default: T) -> CBSubject<T> where T: LosslessStringConvertible {
		let stringSubject = self.stringSubject(forKey: key, default: `default`.description)
		let subject = CBSubject(name: key, `default`)
		stringSubject
			.removeDuplicates()
			.sink { subject.send(T($0) ?? `default`) }
			.store(in: &self.subscriptions)
		subject
			.receive(on: DispatchQueue.global()) // Delay the correction
			.sink { stringSubject.send($0.description) }
			.store(in: &self.subscriptions)
		return subject
	}
}

extension CBUserDefaults: Equatable {
	public static func == (lhs: CBUserDefaults, rhs: CBUserDefaults) -> Bool {
		lhs.name == rhs.name
	}
}

extension CBUserDefaults {
	public static let standard = CBUserDefaults(name: "Standard", from: .standard)
}
