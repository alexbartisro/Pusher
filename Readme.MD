# Pusher

Pusher is a tiny app that leverages Xcode 11.4's feature of sending test notifications to the iOS Simulator.

Requirements: 
* Xcode 11.4 beta 1 installed

Installation:
* Clone, Open Project, Run
or
* Download the latest precompiled version from [here](https://github.com/trusk89/Pusher/releases)

Running:
 * Make sure you have a running iOS simulator
	 * If you don't, start one and click the `Refresh` button
  * **Mandatory** Add the app `Bundle Id` (this is mandatory for the app to be found)
  * Basic Mode
	  * In case your app supports badges, add a badge number
	  * Add the Notification Title, Subtitle and Body (none are mandatory - can be left blank in case you don't want to show an actual notification, but just want to update the badge and play the sound)
* Expert Mode
	* Enter a notification body (basically the JSON which is found in an actual *.apns*)
		```javascript
		{
		   "aps" : {
		      "alert" : {
		         "title" : "Simulated Notifications!",
		         "subtitle" : "Hey There",
		         "body" : "https://github.com/trusk89"
		      }
		   }
		}
		``` 
 * Click `SEND` 


Demo:

![Pusher Demo](demo/demo.gif)

### If you like this project, please consider starring it. Thanks!

#### If you really like it, consider buying me a taco!

[![Taco money](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=J3Z3SVTJ72GJL&currency_code=EUR&source=url)
[![Taco money](https://img.shields.io/badge/patreon-donate-yellow.svg)](https://www.patreon.com/bePatron?u=4249937)
