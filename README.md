# ManageIQ::Schema

[![Build Status](https://travis-ci.com/ManageIQ/manageiq-schema.svg?branch=kasparov)](https://travis-ci.com/ManageIQ/manageiq-schema)
[![Maintainability](https://api.codeclimate.com/v1/badges/f7888b08eb72806b2860/maintainability)](https://codeclimate.com/github/ManageIQ/manageiq-schema/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f7888b08eb72806b2860/test_coverage)](https://codeclimate.com/github/ManageIQ/manageiq-schema/test_coverage)
[![Security](https://hakiri.io/github/ManageIQ/manageiq-schema/kasparov.svg)](https://hakiri.io/github/ManageIQ/manageiq-schema/kasparov)

[![Chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ManageIQ/manageiq-schema?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

SQL Schema and migrations for ManageIQ.

## Development

See the section on plugins in the [ManageIQ Developer Setup](http://manageiq.org/docs/guides/developer_setup/plugins)

For quick local setup run `bin/setup`, which will clone the core ManageIQ repository under the *spec* directory and setup necessary config files. If you have already cloned it, you can run `bin/update` to bring the core ManageIQ code up to date.

### Testing

Unlike other ManageIQ plugins, the schema plugin uses a dummy application in spec/dummy instead of the usual spec/manageiq. This ensure that schema migrations are not dependent on any models or files in ManageIQ core.

To run the tests:

1. If necessary, copy `spec/dummy/config/database.tmpl.yml` to `spec/dummy/config/database.yml` and modify it to access your local database
2. Run: `bin/setup`
   - Copies `spec/dummy/config/database.tmpl.yml` to `spec/dummy/config/database.yml` if it doesn't exist
   - Performs `bundle update`
   - Generates random database region number
   - Creates/resets `dummy_test` database
3. Run: `rspec spec/migrations/<spec_file>` or `rake` (Run all migration tests)

## License

The gem is available as open source under the terms of the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
