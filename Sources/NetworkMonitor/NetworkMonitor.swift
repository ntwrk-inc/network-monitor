import Combine
import Foundation
import Network

public extension NWPathMonitor {
    func publisher(queue: DispatchQueue = .main) -> Publisher {
        Publisher(monitor: self, queue: queue)
    }

    final class Subscription<S: Subscriber>: Combine.Subscription where S.Input == NWPath {
        // MARK: Lifecycle

        public init(subscriber: S, monitor: NWPathMonitor, queue: DispatchQueue) {
            self.subscriber = subscriber
            self.monitor = monitor
            self.queue = queue
        }

        // MARK: Public

        public func request(_ demand: Subscribers.Demand) {
            guard demand == .unlimited else {
                return
            }

            monitor.pathUpdateHandler = { [weak self] value in
                _ = self?.subscriber.receive(value)
            }

            monitor.start(queue: queue)
        }

        public func cancel() {
            monitor.cancel()
        }

        // MARK: Private

        private let subscriber: S
        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
    }

    struct Publisher: Combine.Publisher {
        // MARK: Lifecycle

        public init(monitor: NWPathMonitor, queue: DispatchQueue) {
            self.monitor = monitor
            self.queue = queue
        }

        // MARK: Public

        public typealias Output = NWPath
        public typealias Failure = Never

        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, monitor: monitor, queue: queue)
            subscriber.receive(subscription: subscription)
        }

        // MARK: Private

        private let monitor: NWPathMonitor
        private let queue: DispatchQueue
    }
}
