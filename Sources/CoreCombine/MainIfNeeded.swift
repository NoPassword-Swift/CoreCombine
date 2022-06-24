//
//  MainIfNeeded.swift
//  CoreCombine
//

import Combine
import Dispatch
import Foundation

extension DispatchQueue {
	public struct MainIfNeeded: Scheduler {
		public typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType

		public struct SchedulerOptions {
			var alwaysNeeded: Bool
			var options: DispatchQueue.SchedulerOptions

			public init(alwaysNeeded: Bool = true, options: DispatchQueue.SchedulerOptions = .init()) {
				self.alwaysNeeded = alwaysNeeded
				self.options = options
			}
		}

		public var now: SchedulerTimeType { DispatchQueue.main.now }

		public var minimumTolerance: SchedulerTimeType.Stride { DispatchQueue.main.minimumTolerance }

		public func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
			if !Thread.isMainThread || options?.alwaysNeeded ?? false {
				DispatchQueue.main.schedule(options: options?.options, action)
			} else {
				action()
			}
		}

		public func schedule(after date: DispatchQueue.SchedulerTimeType, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
			fatalError("Delayed scheduling is not implemented for DispatchQueue.MainIfNeeded")
		}

		public func schedule(after date: DispatchQueue.SchedulerTimeType, interval: DispatchQueue.SchedulerTimeType.Stride, tolerance: DispatchQueue.SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
			fatalError("Delayed interval scheduling is not implemented for DispatchQueue.MainIfNeeded")
		}
	}

	public static var mainIfNeeded: MainIfNeeded { MainIfNeeded() }
}
