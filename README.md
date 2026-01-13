# ManageIQ::Schema

[![CI](https://github.com/ManageIQ/manageiq-schema/actions/workflows/ci.yaml/badge.svg?branch=master)](https://github.com/ManageIQ/manageiq-schema/actions/workflows/ci.yaml)

[![Chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ManageIQ/manageiq-schema?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

SQL Schema and migrations for ManageIQ.

## Development

See the section on plugins in the [ManageIQ Developer Setup](http://manageiq.org/docs/guides/developer_setup/plugins)

For quick local setup run `bin/setup`, which will clone the core ManageIQ repository under the *spec* directory and setup necessary config files. If you have already cloned it, you can run `bin/update` to bring the core ManageIQ code up to date.

### Schema Dumper

This repository contains customizations requiring some changes from the default Rails Schema Dumper. The schema dumper should produce a `schema.rb` that when loaded will create an identical schema to the one produced by running the migrations through `rake db:migrate`. To verify the schema dumper is working correctly, you can do the following:

1) Verify each of these steps produce an identical `schema.rb` found in `spec/dummy/db/schema.rb`:

```ruby
rm -f spec/dummy/db/schema.rb; REGION=0 TEST_RAILS_VERSION='8.0' RAILS_ENV=test bundle exec rake app:db:drop app:db:create app:db:migrate
rm -f spec/dummy/db/schema.rb; REGION=0 TEST_RAILS_VERSION='8.0' RAILS_ENV=test bundle exec rake app:db:drop app:db:create app:db:migrate app:db:schema:dump
rm -f spec/dummy/db/schema.rb; REGION=0 TEST_RAILS_VERSION='8.0' RAILS_ENV=test bundle exec rake app:db:drop app:db:create app:db:migrate; REGION=0 TEST_RAILS_VERSION='8.0' RAILS_ENV=test bundle exec rake app:db:schema:dump
```

Note, the second and third examples are testing that global state is not being carried over between runs as `db:migrate` does a `db:schema:dump` so the second example does two separate dump commands. The final one verifies it also works as separate commands.

2) Verify the `schema.rb` generated above is loaded successfully into the database, can then be dumped, and the dumped `schema.rb` is identical to the ones generated above:

```ruby
REGION=0 TEST_RAILS_VERSION='8.0' RAILS_ENV=test bundle exec rake app:db:drop app:db:create app:db:schema:load app:db:schema:dump
```

3) Verify the database created from `app:db:migrate` above is identical to the one from `app:db:schema:load` from the previous step. Use tools such as pgAdmin 4's tools -> schema diff to verify the databases are identical.

### Testing

Unlike other ManageIQ plugins, the schema plugin uses a dummy application in spec/dummy instead of the usual spec/manageiq. This ensures that schema migrations are not dependent on any models or files in ManageIQ core.

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
