#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""The setup script."""

from setuptools import setup, find_packages

with open('README.rst') as readme_file:
    readme = readme_file.read()

with open('HISTORY.rst') as history_file:
    history = history_file.read()

requirements = [
    'Flask==1.1.2',
    'Flask-Dropzone==1.5.4',
    'Flask-WTF==0.14.3',
    'Flask-Limiter==1.4.0',
    'sh==1.14.1',
]

setup_requirements = [
    'pytest-runner',
]

test_requirements = [
    'pytest',
    'coverage',
]

setup(
    author='Moritz Maehr',
    author_email='moritz.maehr@gmail.com',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
    ],
    description='Typademic turns distraction '
    'freely written markdown files into beautiful',
    install_requires=requirements,
    license='MIT license',
    long_description=readme + '\n\n' + history,
    include_package_data=True,
    keywords='typademic',
    name='typademic',
    packages=find_packages(include=['typademic']),
    setup_requires=setup_requirements,
    test_suite='tests',
    tests_require=test_requirements,
    url='https://github.com/maehr/typademic',
    version='1.2.2',
    zip_safe=False,
)
