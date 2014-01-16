Vigilance
=========

vigilance is a sinatra / phantomjs app.  
The root route render a json that contains data about severe weather map in France

Phantomjs is used to scrap the url [http://vigilance.meteofrance.com](http://vigilance.meteofrance.com)  
Sinatra parse data and render json.

##Installation

###Development

    bundle install  
    foreman start

### Deploy on Heroku

    heroku create
    heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git  
    heroku config:add LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib:/app/vendor/phantomjs/lib
    git push heroku master

##Resource

A good resource about create on heroku instance multi buildpack : [http://nerdery.crowdmob.com/post/33143120111/heroku-ruby-on-rails-and-phantomjs](http://nerdery.crowdmob.com/post/33143120111/heroku-ruby-on-rails-and-phantomjs)
