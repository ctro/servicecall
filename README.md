Service Call
===========

Remind Lightspeed customers of upcoming service appointments.

http://servicecall.royowl.net


Run in dev:
-----------
```sh
bundle install
foreman start
```

Console:
--------
```sh
foreman run shell
```

Debugging:
----------
```rb
require 'byebug'
byebug
```

Run tasks:
----------
dev
```sh
RACK_ENV=development foreman run rake mail:service_reminder[3]
```
prod
```sh
heroku run rake mail:service_reminder[3]
```

Run tests:
----------
```sh
foreman run ruby test/*.rb
```

Rerun tests:
```sh
foreman run test
#foreman run rerun ruby test/*.rb
```

Logs:
----------------
[Papertrail](https://papertrailapp.com/systems/lightspeed-servicecall/events)
Or
```sh
heroku addons:open papertrail
```

Monitor:
-----------
- https://uptimerobot.com
- http://servicecall.royowl.net/ping
- http://servicecall.royowl.net/info

Clock:
------
No Cron here, recurring tasks via Heroku "Custom clock process".
TODO: Should this be part of a deploy script?
`heroku ps:scale clock=1`

Deployment:
-----------
Prereqs:
- `servicecall`, `servicecall.pub` keys.

```sh
ssh-add -D
ssh-add ~/.ssh/servicecall
heroku login
heroku keys:add
heroku git:remote add --app lightspeed-servicecall
git push heroku master
```
