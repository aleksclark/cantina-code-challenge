# Cantina Code Challenge

This is a repo hosting my solution to the Cantina code challenge

## Setup

You will need:
* Ruby 2.6.3 (preferably via rvm - rvm will autodetect using the Gemfile)
* Bundler

Install bundled gems:

`bundle`

## Tests

Tests are provided by rspec and located in `spec/`. To run them:

`bundle exec rspec`

## Usage

Run the finder interactively by running:

`bundle exec ruby main.rb FILE_NAME`

Replace `FILE_NAME` with the path to a valid JSON file (one has been supplied in this repo)

## Queries
The Finder 3000 supports a variety of syntaxes to query matching nodes:

* Node Class is queried by a simple string, e.g. `Box`
* The `classNames` property may be queried using a period: `.container`
* The `identifier` property may be queried using a hash (only one per selector!): `#myidentifier`
* Node properties may be queried using `[prop=val]` syntax: `[var=cl_download_maps]`

### Compound Selectors

Selectors may be joined together for a more specific query, e.g.

`VideoModeSelect#videoMode`

### Chained Selectors

Separating selectors by a space will return child nodes of nodes matching the previous selector, e.g.

`Box Input`

or

`Box [var=r_allow_high_dpi]`
