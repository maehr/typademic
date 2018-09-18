#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""The setup script."""

from setuptools import setup, find_packages

with open('README.md') as readme_file:
    readme = readme_file.read()

requirements = [ 'Flask', 'Flask-Dropzone', 'Flask-WTF', 'Flask-Limiter', 'Flask-WTF', 'sh', ]

setup_requirements = ['pytest-runner', ]

test_requirements = ['codecov', 'pytest', 'pytest-cov', 'tox', ]

setup(
    author="Moritz Mähr",
    author_email='moritz.maehr@gmail.com',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
    ],
    description="Typademic turns distraction freely written markdown files into beautiful PDFs.",
    install_requires=requirements,
    license="MIT license",
    long_description=readme,
    include_package_data=True,
    keywords='typademic',
    name='typademic',
    packages=find_packages(include=['typademic']),
    setup_requires=setup_requirements,
    test_suite='tests',
    tests_require=test_requirements,
    url='https://github.com/maehr/typademic',
    version='1.1.1',
    zip_safe=False,
)
