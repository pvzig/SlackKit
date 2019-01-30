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

// Extend all route methods to access path components directly

extension Titan {

    /// Creates a `TitanPathParametersFunc` at the provided path using the `GET` method.
    public func get(_ path: String, handler: @escaping TitanPathParametersFunc) {
        self.get(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `GET` method.
    public func get(path: String, handler: @escaping TitanPathParametersFunc) {
        self.get(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `POST` method.
    public func post(path: String, handler: @escaping TitanPathParametersFunc) {
        self.post(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `POST` method.
    public func post(_ path: String, _ handler: @escaping TitanPathParametersFunc) {
        self.post(path: path, handler: handler)
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `PUT` method.
    public func put(path: String, handler: @escaping TitanPathParametersFunc) {
        self.put(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `PUT` method.
    public func put(_ path: String, _ handler: @escaping TitanPathParametersFunc) {
        self.put(path: path, handler: handler)
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `PATCH` method.
    public func patch(path: String, handler: @escaping TitanPathParametersFunc) {
        self.patch(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `PATCH` method.
    public func patch(_ path: String, _ handler: @escaping TitanPathParametersFunc) {
        self.patch(path: path, handler: handler)
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `DELETE` method.
    public func delete(path: String, handler: @escaping TitanPathParametersFunc) {
        self.delete(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `DELETE` method.
    public func delete(_ path: String, _ handler: @escaping TitanPathParametersFunc) {
        self.delete(path: path, handler: handler)
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `OPTIONS` method.
    public func options(path: String, handler: @escaping TitanPathParametersFunc) {
        self.delete(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `OPTIONS` method.
    public func options(_ path: String, _ handler: @escaping TitanPathParametersFunc) {
        self.options(path: path, handler: handler)
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `HEAD` method.
    public func head(path: String, handler: @escaping TitanPathParametersFunc) {
        self.head(path: path, handler: toTitanFunc(handler, with: path))
    }

    /// Creates a `TitanPathParametersFunc` at the provided path using the `HEAD` method.
    public func head(_ path: String, _ handler: @escaping TitanPathParametersFunc) {
        self.head(path: path, handler: handler)
    }
}
