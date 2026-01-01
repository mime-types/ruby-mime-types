# Contributing

Contribution to mime-types is encouraged in any form: a bug report, a feature
request, or code contributions. New features should be proposed and discussed in
an [issue][issues].

Before contributing patches, please read the [Licence](./LICENCE.md).

MIME::Types is governed under the [Contributor Covenant Code of Conduct][cccoc].

## Code Guidelines

I have several guidelines to contributing code through pull requests:

- All code changes require tests. In most cases, this will be added or updated
  unit tests. I use [Minitest][minitest].

- I use code formatters, static analysis tools, and linting to ensure consistent
  styles and formatting. There should be no warning output from test run
  processes. I use [Standard Ruby][standardrb].

- Proposed changes should be on a thoughtfully-named topic branch and organized
  into logical commit chunks as appropriate.

- Use [Conventional Commits][conventional] with my
  [conventions](#commit-conventions).

- Versions must not be updated in pull requests unless otherwise directed. This
  means that you must not:

  - Modify `VERSION` in `lib/mime/types/version.rb`. When your patch is accepted
    and a release is made, the version will be updated at that point.

  - Modify `mime-types.gemspec`; it is a generated file. (You _may_ use
    `rake gemspec` to regenerate it if your change involves metadata related to
    gem itself).

  - Modify the `Gemfile`.

- Documentation should be added or updated as appropriate for new or updated
  functionality. The documentation is RDoc; mime-types does not use extensions
  that may be present in alternative documentation generators.

- All GitHub Actions checks marked as required must pass before a pull request
  may be accepted and merged.

- Add your name or GitHub handle to `CONTRIBUTORS.md` and a record in the
  `CHANGELOG.md` as a separate commit from your main change. (Follow the style
  in the `CHANGELOG.md` and provide a link to your PR.)

- Include your DCO sign-off in each commit message (see [LICENCE](LICENCE.md)).

## AI Contribution Policy

MIME::Types is a core library with specific expected behaviours. It is extremely
important that contributions of any sort be well understood by the submitter and
that the developer can attest to the [Developer Certificate of Origin][dco] for
each pull request (see [LICENCE](LICENCE.md)).

Any contribution (bug, feature request, or pull request) that uses undeclared AI
output will be rejected.

## Adding or Modifying MIME Types

The mime-types registry is managed in [mime-types-data][mtd].

## Test Dependencies

mime-types uses Ryan Davis's [Hoe][Hoe] to manage the release process, and it
adds a number of rake tasks. You will mostly be interested in `rake`, which runs
the tests the same way that `rake test` will do.

To assist with the installation of the development dependencies for mime-types,
I have provided the simplest possible Gemfile pointing to the (generated)
`mime-types.gemspec` file. This will permit you to do `bundle install` to get
the development dependencies.

You can run tests with code coverage analysis by running `rake coverage`.

## Benchmarks

mime-types offers several benchmark tasks to measure different measures of
performance.

There is a repeated load test, measuring how long it takes to start and load
mime-types with its full registry. By default, it runs fifty loops and uses the
built-in benchmark library:

- `rake benchmark:load`

There are two loaded object count benchmarks (for normal and columnar loads).
These use `ObjectSpace.count_objects`.

- `rake benchmark:objects`
- `rake benchmark:objects:columnar`

## Commit Conventions

MIMe::Types has adopted a variation of the Conventional Commits format for
commit messages. The following types are permitted:

| Type    | Purpose                                               |
| ------- | ----------------------------------------------------- |
| `feat`  | A new feature                                         |
| `fix`   | A bug fix                                             |
| `chore` | A code change that is neither a bug fix nor a feature |
| `docs`  | Documentation updates                                 |
| `deps`  | Dependency updates, including GitHub Actions.         |

I encourage the use of [Tim Pope's][tpope-qcm] or [Chris Beam's][cbeams]
guidelines on the writing of commit messages

I require the use of [git][trailers1] [trailers][trailers2] for specific
additional metadata and strongly encourage it for others. The conditionally
required metadata trailers are:

- `Breaking-Change`: if the change is a breaking change. **Do not** use the
  shorthand form (`feat!(scope)`) or `BREAKING CHANGE`.

- `Signed-off-by`: this is required for all developers except me, as outlined in
  the [Licence](./LICENCE.md#developer-certificate-of-origin).

- `Fixes` or `Resolves`: If a change fixes one or more open [issues][issues],
  that issue must be included in the `Fixes` or `Resolves` trailer. Multiple
  issues should be listed comma separated in the same trailer:
  `Fixes: #1, #5, #7`, but _may_ appear in separate trailers. While both `Fixes`
  and `Resolves` are synonyms, only _one_ should be used in a given commit or
  pull request.

- `Related to`: If a change does not fix an issue, those issue references should
  be included in this trailer.

[cbeams]: https://cbea.ms/git-commit/
[cccoc]: ./CODE_OF_CONDUCT.md
[conventional]: https://www.conventionalcommits.org/en/v1.0.0/
[dco]: licences/dco.txt
[hoe]: https://github.com/seattlerb/hoe
[issues]: https://github.com/mime-types/ruby-mime-types/issues
[minitest]: https://github.com/seattlerb/minitest
[mtd]: https://github.com/mime-types/mime-types-data
[qcm]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[standardrb]: https://github.com/standardrb/standard
[tpope-qcm]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[trailers1]: https://git-scm.com/docs/git-interpret-trailers
[trailers2]: https://git-scm.com/docs/git-commit#Documentation/git-commit.txt---trailerlttokengtltvaluegt
