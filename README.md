# ManageIQ Schema

[![Gem Version](https://badge.fury.io/rb/manageiq-schema.svg)](http://badge.fury.io/rb/manageiq-schema)
[![Build Status](https://travis-ci.com/ManageIQ/manageiq-schema.svg?branch=master)](https://travis-ci.com/ManageIQ/manageiq-schema)
[![Code Climate](https://codeclimate.com/github/ManageIQ/manageiq-schema.svg)](https://codeclimate.com/github/ManageIQ/manageiq-schema)
[![Test Coverage](https://codeclimate.com/github/ManageIQ/manageiq-schema/badges/coverage.svg)](https://codeclimate.com/github/ManageIQ/manageiq-schema/coverage)
[![Security](https://hakiri.io/github/ManageIQ/manageiq-schema/master.svg)](https://hakiri.io/github/ManageIQ/manageiq-schema/master)

[![Chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ManageIQ/manageiq-schema?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

SQL Schema and migrations for ManageIQ

## License

The gem is available as open source under the terms of the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Run Tests in dev environment
1. If necessary, copy `spec/dummy/config/database.tmpl.yml` to `spec/dummy/config/database.yml` and modify it to access your local database
2. Run: `bin/setup`
    1. Copies `spec/dummy/config/database.tmpl.yml` to `spec/dummy/config/database.yml` if it doesn't exist
    2. Performs `bundle update`
    3. Generates random database region number
    4. Creates/resets `dummy_test` database
3. Run: `rspec spec/migrations/<spec_file>`</br>or `rake` (Run all migration tests)
