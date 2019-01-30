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

extension Titan {

    /// Core routing handler for Titan Routing.
    /// Passing `nil` for the method results in matching all methods for a given path
    /// Path matching is defined in `matchRoute` method, documented in `docs/Routes.md`
    public func route(method: HTTPMethod? = nil, path: String, handler: @escaping TitanFunc) {

        let routeFunction: TitanFunc = { (req, res) in

            if let m = method, m != req.method {
                return (req, res)
            }

            guard matchRoute(path: req.path.prefixUpToQuery(), route: path) else {
                return (req, res)
            }

            return handler(req, res)
        }

        addFunction(routeFunction)
    }

    public func route(_ method: HTTPMethod?, _ path: String, _ handler: @escaping TitanFunc) {
        self.route(method: method, path: path, handler: handler)
    }

    /// Synonym for `route`
    public func addFunction(path: String, handler: @escaping TitanFunc) {
        route(path: path, handler: handler)
    }

    public func addFunction(_ path: String, _ handler: @escaping TitanFunc) {
        self.addFunction(path: path, handler: handler)
    }

    /// Synonym for `route`
    public func allMethods(path: String, handler: @escaping TitanFunc) {
        route(path: path, handler: handler)
    }

    public func allMethods(_ path: String, _ handler: @escaping TitanFunc) {
        self.allMethods(path: path, handler: handler)
    }

}

/// Match a given path with a route. Segments containing an asterisk are treated as wild.
/// Assuming querystring has already been stripped, including the question mark
private func matchRoute(path: String, route: String) -> Bool {
    guard !route.contains(where: { (char) -> Bool in
        return char == "*"
    }) else { return true } // If it's a wildcard, bail out – I hope the branch predictor's okay with this!

    guard route.parameters != 0 else {
        return path == route // If there are no wildcards, this is easy
    }

    // PARAMETERS LOGIC
    let splitPath = path.splitOnSlashes() // /foo/bar/baz -> [foo, bar, baz]
    let splitRoute = route.splitOnSlashes() // /foo/{id}/baz -> [foo, {id}, baz]

    guard splitRoute.count == splitPath.count else { // if the number of route segments != path segments, then it can't be a match
        return false
    }

    let zipped = zip(splitPath, splitRoute) // produce [(foo, foo), (bar, *), (baz, baz)]

    for (pathSegment, routeSegment) in zipped {
        // If the route segment does not equal the path segment, and the route segment is not a wildcard, then it does not match
        if (routeSegment != pathSegment) && (!routeSegment.hasPrefix("{") && !routeSegment.hasPrefix("}") ) {
            return false
        } else {
            continue
        }
    }

    return true
}

extension String {
    /// Separate a string into an array of strings, separated by "/" characters
    func splitOnSlashes() -> [String] {
        return self.split(separator: "/").map { String($0) }
    }

    var parameters: Int {
        return self.splitOnSlashes().filter { (value) -> Bool in
            return  value.hasPrefix("{") && value.hasSuffix("}")
        }.count
    }

    /// Return `Self` without the query string.
    func prefixUpToQuery() -> String {
        return self.index(of: "?")
            .map { self.prefix(upTo: $0) }
            .map(String.init) ?? self
    }
}
