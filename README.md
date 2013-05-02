# Hemlock-Frontend
This Rails project serves as the basic UI for [Lab41's Hemlock](http://lab41.github.io/Hemlock).  The basic webapp uses Devise and CanCan for user authentication to a MySQL backend.  The frontend hits a remote ElasticSearch server, as well as the [Hemlock-REST](http://lab41.github.io/Hemlock-REST) API, to deliver search results and display Tenant, System, User, and Role information.

## Deployment
<ol>
<li>Update the following files (<code>grep FIXME -Ri .</code>) with your specific usernames, passwords, servers, and (optionally) environment configuration:
<code><br>
<ul>
    <li>config/application.yml</li>
    <li>config/database.yml</li>
    <li>config/deploy.rb</li>
    </ul>
</code>
</li>

<li>Deploy locally or to a remote server:</li>
    <ul>
    <li>Local: <code>bundle exec rails s</code></li>
    <li>Remote: <code>cap production deploy:setup && cap production deploy:check && cap production deploy</code></li>
    </ul>
</ol>

## Screenshot
![hemlock frontend](https://raw.github.com/Lab41/Hemlock-Frontend/master/app/assets/images/about/screenshot_frontend.png "Hemlock Frontend")

## Architecture
[Hemlock](http://lab41.github.io/Hemlock) Architecture:
![hemlock overview](https://raw.github.com/Lab41/Hemlock/master/docs/images/overview_hemlock.png "Hemlock Overview")

### Foundation
This app was built on top of the RailsApps project [rails3-bootstrap-devise-cancan](https://github.com/RailsApps/rails3-bootstrap-devise-cancan) for Rails 3.2.13 and ruby 1.9.3p194 on top of Ubuntu 13.04
