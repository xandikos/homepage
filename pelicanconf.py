#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Jelmer Vernooĳ'
SITENAME = 'Xandikos'
SITEURL = ''

TIMEZONE = 'Etc/UTC'

DEFAULT_LANG = 'en'

THEME = 'MinimalXY'

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

PLUGINS = ['sitemap']
JINJA_ENVIRONMENT = {
    'extensions': ['jinja2.ext.i18n'],
}
PLUGIN_PATHS = ['plugins']

DEFAULT_PAGINATION = 10

# Menu
DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False

# Social
SOCIAL = (
    ('github', 'https://github.com/jelmer/xandikos'),
)

MENUITEMS = (
    ('News', '/news.html'),
    ('Clients', '/clients.html'),
    ('Standards', '/standards.html'),
    ('Contributing', '/contributing.html'),
    ('Download', '/download.html'),
    ('Help', '/help.html'),
)


STATIC_PATHS = []
EXTRA_PATH_METADATA = {}

DIRECT_TEMPLATES = ['index']
SITEMAP = {'format': 'xml'}

INDEX_SAVE_AS = 'news.html'

SHARE_BUTTONS = []
TAG_CLOUD_SORTING = 'size'
