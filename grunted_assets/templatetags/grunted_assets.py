import os
import re

from django import template
from django.conf import settings
from django.contrib.staticfiles import finders
from django.contrib.staticfiles.templatetags.staticfiles import static

register = template.Library()

DEFAULT_HTML_TAGS = {
    '.css': '<link rel="stylesheet" href="{}">',
    '.js': '<script src="{}"></script>'
}
HTML_TAGS = getattr(settings, 'GRUNTED_ASSETS_HTML_TAGS', DEFAULT_HTML_TAGS)

DEFAULT_DIRS = {
    True: '.tmp',
    False: 'dist'
}
CURRENT_STATIC_DIR = getattr(settings, 'GRUNTED_ASSETS_DIR',
                             DEFAULT_DIRS[settings.DEBUG])


@register.simple_tag
def link_asset(filename):
    """
    The `{% link_asset "<filename_re>" %}` tag is used to get a specific asset
    from either the development or production asset output folders (by default
    `.tmp` and `dist` respectively). You can use a filename regex that will
    match both the file in dev as in production, like for example:
    `'tail.*\.js'`, matching your `tail.js` in development and
    `tail.f23r0df0se.js` in production.

    It will raise an error when zero or multiple files are found.
    """
    # TODO: cache this?
    filename_re = re.compile(filename, re.IGNORECASE)
    found_files = []
    for finder in finders.get_finders():
        for file in finder.list('xyz'):
            if file[0].startswith(CURRENT_STATIC_DIR):
                if filename_re.match(os.path.basename(file[0])):
                    found_files.append(file[0])
    if not found_files:
        raise IOError('Could not find any file matching {} in {}'.format(
                      filename, CURRENT_STATIC_DIR))
    if len(found_files) > 1:
        raise IOError('Found more than one file matching {} in {}: {}'.format(
                      filename, CURRENT_STATIC_DIR, ', '.join(found_files)))
    asset = found_files[0]
    base, ext = os.path.splitext(asset)
    if ext not in HTML_TAGS.keys():
        raise IOError('Found a file matching {} ({}), but no known html tag '
                      'found for this extension {}'.format(filename,
                                                           asset,
                                                           ext))
    return HTML_TAGS[ext].format(static(asset))

