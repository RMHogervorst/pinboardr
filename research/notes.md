
A package to interact with pinboard.

also make it possible to subscribe to public feeds:

>On the web, Pinboard tag/user feeds are presented as such:

https://pinboard.in/u:ticci/ – bookmarks by ticci

https://pinboard.in/t:automation/ – public bookmarks tagged with “automation”

https://pinboard.in/t:ios/t:automation– public bookmarks tagged with “ios” and “automation” 

show example of reading in random article from inspiration feed?

https://pinboard.in/api/






----implement rate limiting and authentification through token.
Authentication

The Pinboard v1 API requires you to use HTTPS. There are two ways to authenticate:

    Regular HTTP Auth:

    https://user:password@api.pinboard.in/v1/method

    API authentication tokens:

    https://api.pinboard.in/v1/method?auth_token=user:NNNNNN

An authentication token is a short opaque identifier in the form "username:TOKEN".

Users can find their API token on their settings page. They can request a new token at any time; this will invalidate their previous API token.

Any third-party sites making API requests on behalf of Pinboard users from an outside server MUST use this authentication method instead of storing the user's password. Violators will be blocked from using the API.
Rate Limits

API requests are limited to one call per user every three seconds, except for the following:

    posts/all - once every five minutes
    posts/recent - once every minute

If you need to make unusually heavy use of the API, please consider discussing it with me first, to avoid unhappiness.

Make sure your API clients check for 429 Too Many Requests server errors and back off appropriately. If possible, keep doubling the interval between requests until you stop receiving errors. 
