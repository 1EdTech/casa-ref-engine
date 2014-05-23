# CASA Engine

The [Community App Sharing Architecture (CASA)](http://imsglobal.github.io/casa) provides a mechanism for
discovering and sharing metadata about web resources such as websites, mobile
apps and LTI tools. It models real-world decision-making through extensible
attributes, filter and transform operations, flexible peering relationships,
etc.

This Ruby gem is the core of the CASA reference implementation, integrating
the [casa-publisher](https://github.com/IMSGlobal/casa-publisher) and [casa-receiver](https://github.com/IMSGlobal/casa-receiver) gems, implementing the CASA Local Module,
providing a hook-based architecture for persistence layers and attributes, and
exposing an interface for administering the engine.

## License

This software is **open-source** and licensed under the Apache 2 license.
The full text of the license may be found in the `LICENSE` file.

## Setup

### Packages

[Ruby](https://www.ruby-lang.org/en/) and [Bundler](http://bundler.io/) must be available on the system to install the CASA Engine.

#### Persistence

Out of the box, the engine supports [MySQL](http://mysql.com), [PostgreSQL](http://www.postgresql.org/) and [SQL Server](http://www.microsoft.com/en-us/sqlserver/default.aspx) as its primary data store. One of these database systems must be running and the engine must be configured to use it.

Additionally, the engine supports [ElasticSearch](http://www.elasticsearch.org/) as its search index database. An instance of ElasticSearch should be running when the engine is started for the engine to use it to provide advanced search functionality; without it, the engine will only allow an outlet to retrieve all payloads or a single payload, not issue queries via text-based search or the ElasticSearch query language.

### Gems

Install gems via Bundler:

```
bundle
```

To avoid installing the dependencies for databases you will not be using, you may use the `--without` option.

To install using the `mysql2` adapter only:

```
bundle --without mssql sqlite
```

To install using the `mssql` adapter only:

```
bundle --without mysql2 sqlite
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

Run the following command to launch the server:

```
bundle exec rackup
```

The server may be run on a different port with the `-p` option, such as on port 80 as:

```
bundle exec rackup -p 80
```
