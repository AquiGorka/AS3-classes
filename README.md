# Actionscript3 for AIR classes

Collection of the classes I used to develop my AIR apps (which were published both for the App Store and Google Play).

## App Lifecycle:
1. Receive a request (not an actual url schema but something on the lines of a get petition)
2. An instance of a RequestHandler class would (via the prepare_dispatch method):
    1. Check which inner handler should answer the request (from a section to an error)
    2. If the request needed data for the view this is where the handlers would fetch it (usually from a database)
    3. Send the data back to the controller
3. An instance of a DispatchManager would (via the dispatch method):
    1. Prepare the stage for the elements to be rendered (usually layout elements that would persist such as headers and footers and dynamic elements such as sections that would change with each request)
    2. Hide previous section elements (each element could leave the stage in any fashioned defined in it's onHide method)
    3. Give control to the current section (via its show method)

### Controller
This is where it all starts. My apps would use an instance of this class as the front controller. There is a debug controller used for development - it already integrates differente profilers and debuggers.

### Components
Collection of UI components classes to handle interactions with the user

### Data
Class that handles Internationalization

### Dispatch
Class that handles the view state rendering

### Interfaces
This define public methods that the instances of the classes use to interact within the app

### Logic
Class that encapsulates database connection and data fetching logic

### Model
Base classes for extending in the app (the most important here being the Section class)


#### License

The MIT License (MIT)

Copyright (c) 2016 Gorka Ludlow <gorka@aquigorka.com> (http://aquigorka.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
