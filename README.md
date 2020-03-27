# StackoverflowStory 

StackOverflow using StoryBoard 


## How to use 
Open the Application 

Login to StackOverflow from the webView 

Once login in you will be taken to a question and answer page where you can search for a question or select the question 

You can upVote, DownVote and Favorite a question 

You can create a question 

You can answer a question 

You can see your fav question (even in webView) 


## Things to keep in mind 
Getting a new access token happens every time your old one expires or doesn't exist 

(I think) you can only post a question per day 

You can only answer a question every 30 seconds

(Core features complete will add extra features later)

## Resources
https://api.stackexchange.com/

###_(How to make your own)_
- Create a stackoverflow account

- Go to Stack Apps and register your app: https://stackapps.com/apps/oauth/register

- Post a question of stackApps (about what you are going to use the service for)

- Use a webview to get the accessToken when logining in as long as you pass in the corrrect urlParameters

Documentation below: 
https://api.stackexchange.com/docs/authentication

Lastly: You can make a custom filter which will allow you to select only the data needed for your use case


### Acknowledgement
Favorited sound provided by: "Power Up, Bright, A.wav" by InspectorJ (www.jshaw.co.uk) of Freesound.org

App Icon from: https://icons8.com/icons/set/stack-overflow
