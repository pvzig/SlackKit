//   Copyright 2017 Enervolution GmbH
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

// Core routing methods for Titan, matching HTTP methods
extension Titan {

    /// Creates a `TitanFunc` at the provided path using the `GET` method.
    public func get(path: String, handler: @escaping TitanFunc) {
        route(method: .get, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `GET` method.
    public func get(_ path: String, _ handler: @escaping TitanFunc) {
        self.get(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `POST` method.
    public func post(path: String, handler: @escaping TitanFunc) {
        route(method: .post, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `POST` method.
    public func post(_ path: String, _ handler: @escaping TitanFunc) {
        self.post(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `PUT` method.
    public func put(path: String, handler: @escaping TitanFunc) {
        route(method: .put, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `PUT` method.
    public func put(_ path: String, _ handler: @escaping TitanFunc) {
        self.put(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `PATCH` method.
    public func patch(path: String, handler: @escaping TitanFunc) {
        route(method: .patch, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `PATCH` method.
    public func patch(_ path: String, _ handler: @escaping TitanFunc) {
        self.patch(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `DELETE` method.
    public func delete(path: String, handler: @escaping TitanFunc) {
        route(method: .delete, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `DELETE` method.
    public func delete(_ path: String, _ handler: @escaping TitanFunc) {
        self.delete(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `OPTIONS` method.
    public func options(path: String, handler: @escaping TitanFunc) {
        route(method: .options, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `OPTIONS` method.
    public func options(_ path: String, _ handler: @escaping TitanFunc) {
        self.options(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `HEAD` method.
    public func head(path: String, handler: @escaping TitanFunc) {
        route(method: .head, path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the `HEAD` method.
    public func head(_ path: String, _ handler: @escaping TitanFunc) {
        self.head(path: path, handler: handler)
    }

    /// Creates a `TitanFunc` at the provided path using the named method.
    public func custom(withName name: String, path: String, handler: @escaping TitanFunc) {
        route(method: .custom(named: name), path: path, handler: handler)
    }

}
