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
- Give the flexibility that compressor provides, linking arbitrary files in certain templates and locations

Where django-compressor falls short
===================================

- Slow compile and reload
- No css injection with livereload
- Not the tools that grunt provides (autoprefixer, uglify, etc)
- Inlining assets

How it works
============

1. Put your static where you normally do, e.g. in a top level 'static' or
   'assets' dir, or in the 'static' dir in your app.
2. Configure the paths in your gruntfile.
3. Add ``{% load grunted_assets %}`` to your (base) template and link the
   assets you want to load with: ``{% link_asset 'script.js' %}``
4. Run grunt (see below).
5. Run ``django-admin.py collectstatic``

The ``link_asset`` template tag (or the ``inline_asset`` tag), searches for the
files in either ``.tmp`` (development) or ``dist`` (production) within
``STATIC_ROOT``.

The argument you pass to ``link_asset`` of ``inline_asset`` is treated as a regex. A
simple ``main.css`` therefore works, but using ``.*main\.js`` for example, you can
also match files processed with something like
``grunt-rev<https://www.npmjs.com/package/grunt-rev>``_.

Development
-----------

In development (``grunt`` or ``grunt develop``), grunt compiles sass and coffee-
script to a ``.tmp`` dir inside 'static'. These files get served by node. No
cache busting here.

All static will be served by ``connect`` on ``localhost:8001``, so set
``STATIC_URL='http://localhost:8001``

Production
----------

Run ``grunt dist`` and check the ``dist`` folder into source control. This will
concat, minify etc. all your js and css into 'main.css' and 'main.js' as you
specify in your gruntfile.

On the server run ``django-admin.py collectstatic`` to have all static files
collected to the proper place.
