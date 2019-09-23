# T1_Assessment

### Problem
Mary has turned several rooms of her house into an IoT enabled smart home, and she would like to turn on and off the fixtures through her phone. She would also want the AC fixture to be turned on and off automatically based on the current temperature.

### Solution
Based on Mary's requirement, an iOS app is built to show all the rooms and their respective fixtures. Each fixture is equiped with a switch. Assuming Mary prefers the AC fixture to be **always** switched on and off automatically, this particular switch cannot be manually toggled.

### Techincal Discussion
The app can be tested by dowload this project and run it through Xcode stimulators or an iPhone.
In terms of architecture, MVC approach has been applied. Models for rooms API and weather API were created while view was mosly composed by UITableView. The two UIViewController provided the data to the view and handled the user events from the view.

### Improvement
* Refactoring the functions of getting JSON data from API
* Fetch and check the weather data when the app is launched or is back on the Home Screen, rather than having it done in the   Fixture Screen
* Improve overall UI
