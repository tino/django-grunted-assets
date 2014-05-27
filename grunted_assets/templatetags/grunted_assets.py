import json

from django import template
from django.contrib.staticfiles import finders
from django.contrib.staticfiles.templatetags.staticfiles import static


register = template.Library()

HTML_TAGS = {
    'css': '<link rel="stylesheet" href="{}">',
    'js': '<script src="{}"></script>'
}


@register.simple_tag
def assets(type_):
    """
    The ``{% assets %}`` tag can be used in two different ways. With a single
    argument (css or js) the tag outputs the required html elements to load
    these files. Using it as an assignment tag ``{% assets css as css_files %}``
    it assigns the filenames to the given variable name, so that you can render
    the link or script elements yourself.
    """
    assert type_ in HTML_TAGS
    asset_file_dev = finders.find('.tmp/asset-manifest.json')
    asset_file_prod = finders.find('dist/asset-manifest.json')
    assert asset_file_dev or asset_file_prod, "Could not find an asset-manifest.json!"
    with open(asset_file_dev or asset_file_prod) as f:
        manifest = json.load(f)
    output = []
    for file in manifest[type_]:
        output.append(HTML_TAGS[type_].format(static(file)))
    return '\n'.join(output)
