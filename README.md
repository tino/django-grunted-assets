# django-grunted-assets

## Goal

- Have css and js compressed and cache busted in production
- Have livereload work with css injection in development
- Have livereload work with coffee-script files and html templates
- Have node serve our staticfiles in development as it is way faster than django's runserver

## Where django-compressor fails

- Slow compile and reload
- No css injection with livereload

## Look at

- https://github.com/Luismahou/grunt-hashres
- https://www.npmjs.org/package/grunt-asset-manifest
- https://github.com/vanetix/grunt-asset-revisions/blob/master/tasks/revisions.js
- https://github.com/verbling/assetflow#grunt-task-assetsbundle

## How it works

1. Put your static where you normaly do, e.g. in a top level 'static' or 'assets' dir, or in the 'static' dir in your app.
2. Configure the paths in grunt
3. In development (``grunt`` or ``grunt develop``), grunt compiles sass and coffee-script to a ``.tmp`` dir inside 'static'. These files get served by node. No cache busting here.
4. Before you commit (commit hook!), run ``grunt production``. This will concat, minify etc. all your js and css into 'main.css' and 'main.js'

## Development

- Lets keep files as small as possible, as that saves grunt time.
-

## To Solve

- What to do with static files from other django apps? Leave them for now. Mostly admin, and that isn't high traffic frontend. And you don't change those files.
