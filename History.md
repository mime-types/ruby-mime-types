## 3.2 / 2018-08-12

*   2 minor enhancements

    *   Janko Marohnić contributed a change to `MIME::Type#priority_order` that
        should improve on strict sorting when dealing with MIME types that
        appear to be in the same family even if strict sorting would cause an
        unregistered type to be sorted first. [#132][]

    *   Dillon Welch contributed a change that added `frozen_string_literal:
        true` to files so that modern Rubies can automatically reduce duplicate
        string allocations. [#135][]

*   1 bug fix

    *   Burke Libbey fixed a problem with cached data loading. [#126][]

*   Deprecations:

    *   Lazy loading (`$RUBY_MIME_TYPES_LAZY_LOAD`) has been deprecated.

*   Documentation Changes:

    *   Supporting files are now Markdown instead of rdoc, except for the
        README. 

    *   The history file has been modified to remove all history prior to 3.0.
        This history can be found in previous commits.

    *   A spelling error was corrected by Edward Betts ([#129][]).

*   Administrivia:

    *   CI configuration for more modern versions of Ruby were added by Nicolas
        Leger ([#130][]) and Jun Aruga ([#125][]).

    *   Fixed test which were asserting equality against nil, which will become
        an error in Minitest 6.

## 3.1 / 2016-05-22

*   1 documentation change:

    *   Tim Smith (@tas50) updated the build badges to be SVGs to improve
        readability on high-density (retina) screens with pull request
        [#112][].

*   3 bug fixes

    *   A test for `MIME::Types::Cache` fails under Ruby 2.3 because of frozen
        strings, [#118][]. This has been fixed.

    *   The JSON data has been incorrectly encoded since the release of
        mime-types 3 on the `xrefs` field, because of the switch to using a Set
        to store cross-reference information. This has been fixed.

    *   A tentative fix for [#117][] has been applied, removing the only
        circular require dependencies that exist (and for which there was code
        to prevent, but the current fix is simpler). I have no way to verify
        this fix and depending on how things are loaded by `delayed_job`, this
        fix may not be sufficient.

*   1 governance change

    *   Updated to Contributor Covenant 1.4.

## 3.0 / 2015-11-21

*   2 governance changes

    *   This project and the related mime-types-data project are now
        exclusively MIT licensed. Resolves [#95][].

    *   All projects under the mime-types organization now have a standard code
        of conduct adapted from the [Contributor Covenant][]. This text can be
        found in the [Code-of-Conduct.md][] file.

*   3 major changes

    *   All methods deprecated in mime-types 2.x have been removed.

    *   mime-types now requires Ruby 2.0 compatibility or later. Resolves
        [#97][].

    *   The registry data has been removed from mime-types and put into
        mime-types-data, maintained and released separately. It can be found at
        [mime-types-data][].

*   17 minor changes:

    *   `MIME::Type` changes:

        *   Changed the way that simplified types representations are created
            to reflect the fact that `x-` prefixes are no longer considered
            special according to IANA. A simplified MIME type is case-folded to
            lowercase. A new keyword parameter, `remove_x_prefix`, can be
            provided to remove `x-` prefixes.

        *   Improved initialization with an Array works so that extensions do
            not need to be wrapped in another array. This means that
            `%w(text/yaml yaml yml)` works in the same way that
            `['text/yaml', %w(yaml yml)]` did (and still does).

        *   Changed `priority_compare` to conform with attributes that no
            longer exist.

        *   Changed the internal implementation of extensions to use a frozen
            Set.

        *   When extensions are set or modified with `add_extensions`, the
            primary registry will be informed of a need to reindex extensions.
            Resolves [#84][].

        *   The preferred extension can be set explicitly. If not set, it will
            be the first extension. If the preferred extension is not in the
            extension list, it will be added.

        *   Improved how xref URLs are generated.

        *   Converted `obsolete`, `registered` and `signature` to
            `attr_accessors`.

    *   `MIME::Types` changes:

        *   Modified `MIME::Types.new` to track instances of `MIME::Types` so
            that they can be told to reindex the extensions as necessary.

        *   Removed `data_version` attribute.

        *   Changed `#[]` so that the `complete` and `registered` flags are
            keywords instead of a generic options parameter.

        *   Extracted the class methods to a separate file.

        *   Changed the container implementation to use a Set instead of an
            Array to prevent data duplication. Resolves [#79][].

    *   `MIME::Types::Cache` changes:

        *   Caching is now based on the data gem version instead of the
            mime-types version.

        *   Caching is compatible with columnar registry stores.

    *   `MIME::Types::Loader` changes:

        *   `MIME::Types::Loader::PATH` has been removed and replaced with
            `MIME::Types::Data::PATH` from the mime-types-data gem. The
            environment variable `RUBY_MIME_TYPES_DATA` is still used.

        *   Support for the long-deprecated mime-types v1 format has been
            removed.

        *   The registry is default loaded from the columnar store by default.
            The internal format of the columnar store has changed; many of the
            boolean flags are now loaded from a single file. Resolves [#85][].

[#112]: https://github.com/mime-types/ruby-mime-types/pull/112
[#117]: https://github.com/mime-types/ruby-mime-types/pull/117
[#118]: https://github.com/mime-types/ruby-mime-types/pull/118
[#132]: https://github.com/mime-types/ruby-mime-types/pull/132
[#135]: https://github.com/mime-types/ruby-mime-types/pull/135
[#79]: https://github.com/mime-types/ruby-mime-types/pull/79
[#84]: https://github.com/mime-types/ruby-mime-types/pull/84
[#85]: https://github.com/mime-types/ruby-mime-types/pull/85
[#95]: https://github.com/mime-types/ruby-mime-types/pull/95
[#97]: https://github.com/mime-types/ruby-mime-types/pull/97
[Code-of-Conduct.md]: Code-of-Conduct_md.html
[Contributor Covenant]: http://contributor-covenant.org
[mime-types-data]: https://github.com/mime-types/mime-types-data
