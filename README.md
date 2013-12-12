# CASA Engine

[![Build Status](https://travis-ci.org/AppSharing/casa-engine.png)](https://travis-ci.org/AppSharing/casa-engine) [![Dependency Status](https://gemnasium.com/AppSharing/casa-engine.png)](https://gemnasium.com/AppSharing/casa-engine) [![Code Climate](https://codeclimate.com/github/AppSharing/casa-engine.png)](https://codeclimate.com/github/AppSharing/casa-engine)

## Setup

### Gems

Install gems via Bundler:

```
bundle
```

To exclude database adapters you do not play on using, you may use the `--without` option.

To install using the `mysql2` adapter only:

```
bundle --without mssql sqlite
```

To install using the `mysql2` adapter only:

```
bundle --without mssql sqlite
```

To install using the `sqllite` adapter only:

```
bundle --without mysql2 mssql
```

### Settings File

Run the setup utility:

```
thor engine:setup
```

## Run

```
bundle exec rackup
```