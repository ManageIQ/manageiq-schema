# ManageIQ::Schema

[![CI](https://github.com/ManageIQ/manageiq-schema/actions/workflows/ci.yaml/badge.svg?branch=master)](https://github.com/ManageIQ/manageiq-schema/actions/workflows/ci.yaml)

[![Chat](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/ManageIQ/manageiq-schema?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

SQL Schema and migrations for ManageIQ.

## Development

See the section on plugins in the [ManageIQ Developer Setup](http://manageiq.org/docs/guides/developer_setup/plugins)

For quick local setup run `bin/setup`, which will clone the core ManageIQ repository under the *spec* directory and setup necessary config files. If you have already cloned it, you can run `bin/update` to bring the core ManageIQ code up to date.

### Testing the Schema With a New Rails Version

This repository contains customizations to the default Rails schema dumper. When adding support for a new Rails version, verify that both versions produce identical schemas — both on the Ruby/Rails side (`schema.rb`) and at the PostgreSQL level. For each Rails version, two outputs are captured: one from running migrations (`migrate`) and one from loading the dumped schema into a fresh database (`load`). Comparing all four outputs confirms the dumper round-trips correctly (`schema.rb`), and that the actual database structures match at the SQL level (pgAdmin schema diff).

#### Version variables

Set these once in your shell before running any commands below.

```bash
OLD='80'
NEW='81'
```

#### Capture schema outputs

The script below drops and recreates the database, runs migrations (saving the resulting `schema.rb` as `.migrate`), then loads that schema into a fresh database and redumps it (saving the result as `.load`). Run it twice: first with `VER="${OLD}"`, then with `VER="${NEW}"`:

```bash
rm -f spec/dummy/db/schema.rb
DATABASE_URL=postgres://localhost/dummy_test_${VER}_migrate \
  REGION=0 TEST_RAILS_VERSION="${VER:0:1}.${VER:1}" RAILS_ENV=test \
  bundle exec rake app:db:drop app:db:create app:db:migrate
cp spec/dummy/db/schema.rb spec/dummy/db/schema.rb.${VER}.migrate

cp spec/dummy/db/schema.rb.${VER}.migrate spec/dummy/db/schema.rb
DATABASE_URL=postgres://localhost/dummy_test_${VER}_load \
  REGION=0 TEST_RAILS_VERSION="${VER:0:1}.${VER:1}" RAILS_ENV=test \
  bundle exec rake app:db:drop app:db:create app:db:schema:load app:db:schema:dump
cp spec/dummy/db/schema.rb spec/dummy/db/schema.rb.${VER}.load
```

`TEST_RAILS_VERSION` switches Rails versions without a `bundle update`. The `rm -f` before the migrate run is required — if a `schema.rb` from a different Rails version is present, the migrate task will fail with an `Unknown migration version` error.

#### Compare `schema.rb` files

```bash
git diff --no-index spec/dummy/db/schema.rb.${OLD}.migrate spec/dummy/db/schema.rb.${OLD}.load
git diff --no-index spec/dummy/db/schema.rb.${NEW}.migrate spec/dummy/db/schema.rb.${NEW}.load
git diff --no-index spec/dummy/db/schema.rb.${OLD}.migrate spec/dummy/db/schema.rb.${NEW}.migrate
git diff --no-index spec/dummy/db/schema.rb.${OLD}.load    spec/dummy/db/schema.rb.${NEW}.load
```

#### Compare databases with pgAdmin

Use pgAdmin's schema diff tool (Tools → Schema Diff) to compare each pair of databases:

- `dummy_test_${OLD}_migrate` vs `dummy_test_${OLD}_load`
- `dummy_test_${NEW}_migrate` vs `dummy_test_${NEW}_load`
- `dummy_test_${OLD}_migrate` vs `dummy_test_${NEW}_migrate`
- `dummy_test_${OLD}_load` vs `dummy_test_${NEW}_load`

#### Expected results

| Comparison | Expected |
|---|---|
| `${OLD}.migrate` vs `${OLD}.load` | Identical |
| `${NEW}.migrate` vs `${NEW}.load` | Identical |
| `${OLD}.migrate` vs `${NEW}.migrate` | Identical (schema version comment may differ) |
| `${OLD}.load` vs `${NEW}.load` | Identical (schema version comment may differ) |

#### Cleanup

```bash
rm spec/dummy/db/schema.rb.${OLD}.migrate spec/dummy/db/schema.rb.${OLD}.load \
   spec/dummy/db/schema.rb.${NEW}.migrate spec/dummy/db/schema.rb.${NEW}.load
```

### Validating an Application (e.g. manageiq)

After verifying the schema dumper in this repository, repeat the same process in the application that consumes manageiq-schema (e.g. [manageiq](https://github.com/ManageIQ/manageiq)). The Rails version there is set by the `rails` gem pin in the Gemfile. Note that `db:setup` and `db:reset` are blocked in manageiq — always use `db:drop db:create db:migrate` directly.

For each version, set up the appropriate branch and update the `rails` gem (`bundle update rails`), then run the script below. Run it twice: first with `VER="${OLD}"`, then with `VER="${NEW}"`:

```bash
rm -f db/schema.rb
DATABASE_URL=postgres://localhost/vmdb_test_${VER}_migrate \
  REGION=0 RAILS_ENV=test \
  bundle exec rake db:drop db:create db:migrate
cp db/schema.rb db/schema.rb.${VER}.migrate

cp db/schema.rb.${VER}.migrate db/schema.rb
DATABASE_URL=postgres://localhost/vmdb_test_${VER}_load \
  REGION=0 RAILS_ENV=test \
  bundle exec rake db:drop db:create db:schema:load db:schema:dump
cp db/schema.rb db/schema.rb.${VER}.load
```

#### Compare

```bash
git diff --no-index db/schema.rb.${OLD}.migrate db/schema.rb.${OLD}.load
git diff --no-index db/schema.rb.${NEW}.migrate db/schema.rb.${NEW}.load
git diff --no-index db/schema.rb.${OLD}.migrate db/schema.rb.${NEW}.migrate
git diff --no-index db/schema.rb.${OLD}.load    db/schema.rb.${NEW}.load
```

Then use pgAdmin's schema diff tool (Tools → Schema Diff) to compare the same four pairs of databases (`vmdb_test_*`). See [Expected results](#expected-results) above — the same criteria apply.

#### Cleanup

```bash
rm db/schema.rb.${OLD}.migrate db/schema.rb.${OLD}.load \
   db/schema.rb.${NEW}.migrate db/schema.rb.${NEW}.load
```

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
