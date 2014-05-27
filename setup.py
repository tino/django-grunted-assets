import os
from setuptools import setup, find_packages


def read_file(filename):
    """Read a file into a string"""
    path = os.path.abspath(os.path.dirname(__file__))
    filepath = os.path.join(path, filename)
    try:
        return open(filepath).read()
    except IOError:
        return ''


setup(
    name='django-grunted-assets',
    version=__import__('grunted_assets').__version__,
    author='Tino de Bruijn',
    author_email='tinodb@gmail.com',
    packages=find_packages(),
    include_package_data=True,
    url='https://github.com/tino/django-grunted-assets',
    license='MIT',
    description=' '.join(__import__('grunted_assets').__doc__.splitlines()).strip(),
    classifiers=[
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Framework :: Django',
        'Development Status :: 4 - Beta',
        'Operating System :: OS Independent',
    ],
    long_description=read_file('README.rst'),
    zip_safe=False,
)
