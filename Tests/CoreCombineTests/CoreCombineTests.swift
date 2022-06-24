//
//  CoreCombineTests.swift
//  CoreCombineTests
//

import XCTest
@testable import CoreCombine

final class CoreCombineTests: XCTestCase {
	func testMainIfNeeded_Immediate() {
		let subject = CBSubject(name: "Main If Needed", true)
		var result = false
		_ = subject
			.receive(on: DispatchQueue.mainIfNeeded)
			.sink { result = $0 }
		XCTAssert(result)
	}

	func testMainIfNeeded_Delayed() {
		let subject = CBSubject(name: "Main If Needed", false)
		var result = false
		let cancel = subject
			.receive(on: DispatchQueue.mainIfNeeded)
			.sink { result = $0 }
		XCTAssertFalse(result)
		withExtendedLifetime(cancel) { subject.send(true) } // Ensure we stay subscribed
		XCTAssert(result)
	}
}
