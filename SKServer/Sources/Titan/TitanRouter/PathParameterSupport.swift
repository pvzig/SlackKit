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

public typealias PathParameters = [String: String]
public typealias TitanPathParametersFunc = (RequestType, ResponseType, PathParameters) -> (RequestType, ResponseType)

func toTitanFunc(_ handler: @escaping TitanPathParametersFunc, with pathTemplate: String) -> TitanFunc {

    return { req, res in
        let params = parameters(from: req.path, with: pathTemplate)
        return handler(req, res, params)
    }
}

/// Extract the parameters from a path given a template.
/// It is a programmer error to pass a path template containing a different number of components to the path itself,
/// and may result in undefined behavior.
/// Where the `path` is /users/567/email
/// Where the `template` is /users/{id}/email
/// return ["id":"567"]
func parameters(from path: String, with template: String) -> PathParameters {
    // Split the path and the template into its individual parts
    var params: [String: String] = [:]
    let pathComps = path.splitOnSlashes()
    let templateComps = template.splitOnSlashes()
    // Zip them together
    let z = zip(pathComps, templateComps)

    for (pathComp, templateComp) in z {
        guard templateComp.hasPrefix("{") && templateComp.hasSuffix("}") else {
            continue
        }
        let key = String((templateComp.dropFirst()).dropLast())
        params[key] = pathComp
    }
    return params
}
