# TitanCore

TitanCore is a tiny Swift class that can be configured with `middleware` functions that are called in order when the `app` method is called.


## Functionality
The middleware functions receive a request and response object as input and must return a request and response object as output. There is no requirement that the outputs resemble the inputs in any way; however, it is expected that middlewares behave in a conservative and respectful fashion to their inputs. Middlewares should embrace the single responsibility principle: as a rule, they should only modify one property of either the request or the response. Multiple middlewares are always preferred over single middlewares.

