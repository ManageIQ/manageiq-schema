# Contributing

Please read the [ManageIQ guides](http://github.com/ManageIQ/guides) before contributing.

The guides contain our Ruby coding standards as well as general standards around commits, pull requests, and more.

## Development considerations

The following are some general guidelines that reviewers will be looking for when reviewing your PR.  Please consider them when making a PR.

Primarily, reviewers will be looking for

- Database schema issues that could lead to performance/inefficiency problems, as well as index selection
- Rails-inconsistent column names such as non-foreign-keys that end in _id or a type column that isn't being used for STI
- Understanding where the new tables fits in the grand scheme and what use cases it is supporting. For providers, it's important to understand if the new tables and the naming of things fits into the single pane of glass, and how those new tables would be reused by other provider of the same provider type.

Depending on the migration type they will also be looking for the following.

### All migrations

- Avoid mixing schema and data changes in a single migration.  Instead, create separate migrations.

### Schema migrations

- Avoid using default values and foreign keys.  The reason is because we don't allow new schema migrations in a released branch, as schema migrations would require downtime, which we want to avoid for patch-level updates.  Database level decisions like default values and foreign key constraints therefore cannot be undone, whereas if they are encoded in the model, they can be changed in a patch-level release.
- If `remove_column` is used, the PR description should show linked PRs from other repos, or a GitHub search, verifying that those columns are no longer used.

### Data migrations

- All data migrations must have specs
- Use `say_with_time` around data migration code.  With say_with_time you get a consistent output when migrating, and we can see how long a particular migration takes.
- When you are working with a model in data migration, define the model stub in the migration directly
  - Be sure that any associations (e.g. `has_many`), specify the class directly so that it uses the correct model.
  - Use `ActiveRecord::Base` as opposed to `ApplicationRecord`.  Part of the advantage of `ApplicationRecord` is that `ActiveRecord::Base` is left unmodified, which is exactly what we prefer in migrations.

- When there is model defined in your migration and it has column `type`, set the inheritance column to avoid accidental STI.  For example,

  ```ruby
  class CloudNetwork < ActiveRecord::Base
    self.inheritance_column = :_type_disabled
  end
  ```

- Prefer `update_all` where appropriate.  `update_all` is significantly faster than 1-by-1 `update` calls.
- If a data migration could affect a large number of rows (e.g. millions of rows), consider using batching techniques, with progress output, and making the migration reentrant.  In this way, data will be continually committed in batches, and if the migration fails for some reason, the progress made won't be lost due to a `ROLLBACK`.  If made reentrant, the user can just restart `db:migrate`, and it should pick up where it left off.
- Data migrations should not create new rows if rows didn't previously exist.  That is, an empty database migrated should still be empty in the end, particularly for test reasons.  Data migrations of existing data can transform into new rows, if necessary.
- Data migrations should be region-aware.  When a data migration runs in the global region, you probably only want to update records for your region (especially when the data migration is complicated). Updating records for other regions is a waste of time since the migration will also be run in the remote region and it will push the changes up during replication.
- Avoid deserializing columns that might have serialized objects in them, as the models they represent will not be available to the migration causing failures.  An example is `MiqExpression`, which is commonly stored as a seralized object in report columns.  Instead of deserializing, prefer `LIKE` queries and simple String manipulations, if possible.
