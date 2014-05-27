=====================
django-grunted-assets
=====================

Goal
====

- Have css and js compressed and cache busted in production
- Have livereload work with css injection in development
- Have livereload work with coffee-script files and html templates
- Have node serve our staticfiles in development as it is way faster than
  django's runserver

Where django-compressor fails
=============================

- Slow compile and reload
- No css injection with livereload

How it works
============

1. Put your static where you normaly do, e.g. in a top level 'static' or
   'assets' dir, or in the 'static' dir in your app.
2. Configure the paths in your gruntfile.
3. Add the `{% load grunted_assets %}` to your (base) template and load the css
   with: `{% assets css %}` and the js (surprisingly) with `{% assets js %}`.
3. Run grunt (see below).
4. Run `django-admin.py collectstatic`

The `assets` template tag gets the files needed from the `asset-manifest.json`
file, that is either placed in `.tmp` (development) or `dist` (production).

Development
-----------

In development (``grunt`` or ``grunt develop``), grunt compiles sass and coffee-
script to a ``.tmp`` dir inside 'static'. These files get served by node. No
cache busting here.

All static will be served by `connect` on `localhost:8001`, so set
`STATIC_URL='http://localhost:8001`

Production
----------

Run ``grunt dist`` and check the `dist` folder into source control. This will
concat, minify etc. all your js and css into 'main.css' and 'main.js' as you
specify in your gruntfile.

On the server run `django-admin.py collectstatic` to have all static files
collected to the proper place.

TODO
----

- What to do with static files from other django apps? Leave them for now.
  Mostly admin, and that isn't high traffic frontend. And you don't change those
  files. If you do want to incorporate them, include them in your grunt file!
- django management command that enables grunt to know where certain static
  files of apps live.

Maybe helpful?
--------------

- https://github.com/vanetix/grunt-asset-revisions/blob/master/tasks/revisions.js
- https://github.com/verbling/assetflow#grunt-task-assetsbundle
