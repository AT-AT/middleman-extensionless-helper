# Middleman-Extensionless-Helper

middleman-extensionless-helper is a Middleman(only for v3) extension to remove a file extension which is attached to extension-less file by the "automatically adding content extensions" feature in a build process.

Currently, this extension only works for ERb, and works for files that are specified in the option of this extension.

### What is the "automatically adding content extensions"?

Let's say, Middleman builds the following file

```
source/foo.erb
```

to

```
build/foo.html.erb
```

This is the "automatically adding content extensions" feature.
But in some cases, we want to avoid this feature.
This extension renames it to

```
build/foo
```

However, Middleman builds following files

```
source/
  .erb
  .foo.erb
  bar.txt.erb
  baz.quux.erb
```

to

```
build/
  # ".erb" and ".foo.erb" does not be built,
  # because Middleman only builds ".htaccess" and ".htpasswd" on the dot file.
 
  # Middleman does not attach extension to a file which has some extension.
  bar.txt
  baz.quux
```

So, this extension never handle those files. 

### Why only for v3?

Because Middleman-v4 does not have the "automatically adding content extensions" feature. 
See [this issue](https://github.com/middleman/middleman/issues/1211).

### Why only for ERb?

Because others are not general-purpose format like as ERb, IMO there is no need to handle them.

## Installation

Add the following line to the Gemfile of your Middleman project:

```ruby
gem "middleman-extensionless-helper"
```

Then as usual, run:

```sh
bundle install
```

## Usage

To activate and configure this extension, add the following configuration block to Middleman's config.rb:

```ruby
activate :extensionless_helper do |f|
  # The "target" option has been initialized with a empty Array.
  f.target << 'foo.erb' # assumed to be placed in "source/foo.erb"
  # It is possible to change whole the value.
  f.target = ['foo.erb', 'bar/baz.erb'] # assumed to be placed in "source/foo.erb", "source/bar/baz.erb"
end
```

| Option     | Description
| ---------- | ------------
| target     | An array with target files placed in a `source` directory.<br>Relative path from the `source` directory is acceptable.

## Build Messages

This extension displays some messages in a build process as below.

Let's say, beginning state is:

```
build/
  (empty)
source/
  foo.erb
```

Run build, then messages are:

```
   create build/foo.html               <-- Middleman says
EH:rename build/foo.html => build/foo  <-- This extension says
```

Then, state is:

```
build/
  foo
source/
  foo.erb
```

Just build again without any change, then messages are:

```
identical build/foo.html                           <-- Middleman says
EH:rename build/foo.html => build/foo (identical)  <-- This extension says
```

Then, state is:

```
build/
  foo
source/
  foo.erb
```

Change `foo.erb` and build, then messages are:

```
   update build/foo.html                        <-- Middleman says
EH:rename build/foo.html => build/foo (update)  <-- This extension says
```

Then, state is:

```
build/
  foo
source/
  foo.erb
```

Remove `foo.erb` and build, then messages are:

```
   remove build/foo.html  <-- Middleman says
EH:remove build/foo       <-- This extension says
```

Then, state is:

```
build/
  (empty)
source/
  (empty)
```

Just build again, then messages are:

```
EH:no-target build/foo  <-- This extension says
```

## Development

Personal references:
  * [Middleman-v3 - Document/custom extensions](https://github.com/middleman/middleman-guides/blob/v3/source/localizable/advanced/custom_extensions.jp.html.markdown)
  * [Middleman-v3 - steps](https://github.com/middleman/middleman/tree/v3-stable/middleman-core/lib/middleman-core/step_definitions)
  * [Cucumber-ruby](https://github.com/cucumber/cucumber-ruby)
  * [Aruba](https://github.com/cucumber/aruba)
  * [Thor - Actions](http://www.rubydoc.info/github/wycats/thor/Thor/Actions)
  * [Thor - Shell/Basic](http://www.rubydoc.info/github/wycats/thor/Thor/Shell/Basic)

## TODO

* Add unit test.
* Consider test for displaying message.

## License

(c) 2016 AT-AT. MIT Licensed, see [LICENSE] for details.
