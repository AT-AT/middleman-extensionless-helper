module Middleman
  module ExtensionLessHelper
    class Extension < ::Middleman::Extension
      option :target, [], 'Target files/paths from the source directory'

      EXTENSION_MAP = {
        '.erb' => '.html'
      }


      def initialize(app, options_hash={}, &block)
        super

        require 'digest/sha2'
        require 'fileutils'
        require 'ostruct'

        @target = create_target(options.target)
      end


      #
      # Hooks
      #

      public

      def after_configuration

        # Avoid applying a layout to target files.
        # #page requires a URL having a absolute path from the root that is not the source directory
        # but the web site. Besides, because it's the URL, a file name in it must be the same as MM
        # names in a build process. Hence the URL looks like "/foo.html"(the original file is "foo").
        @target.each do |target|
          app.page File.join('', target.build), :layout => false
        end

      end

      def before_build(builder)

        # Rename target files in the build directory for avoiding a "create" message by MM.
        #  e.g. build/foo -> build/foo.html
        # Because target files are renamed by this extension in a previous build process, MM cannot 
        # find them and assumes that they are newly created and displays a "create" message.
        # So, restore a name of target files to one which MM names in a build process.
        @target.each do |target|
          rename_build_file(target.expect, target.build)
        end

        # SHOULD do after above the process, because a build path in a target object is referred.
        inject_target_state

      end

      def after_build(builder)

        # Rename target files in the build directory as we expect.
        #  e.g. build/foo.html -> build/foo
        @target.each do |target|
          rename_build_file(target.build, target.expect)

        # SHOULD do after above the process, because a build path in a target object is referred.
          present_status(builder, target)

        end

      end


      #
      # Internals
      #

      private

      def convert_source_path(source)
        # This isn't a smart way, but shouldn't use #split|Regexp because there're some "edge" cases.

        template_exts = EXTENSION_MAP.keys

        first_ext = File.extname(source).downcase
        return {} unless template_exts.include?(first_ext)

        expected_path = source.sub(/#{Regexp.quote(first_ext)}$/i, '')
        return {} if File.extname(expected_path) != ''

        base_name = File.basename expected_path
        return {} if base_name.start_with?('.') && !base_name.match(/^\.ht(?:access|passwd)$/)

        build_ext = EXTENSION_MAP[first_ext]
        {build: (expected_path + build_ext), expect: expected_path}
      end

      def create_target(target)

        # SHOULD NOT check an existence of file in here, because files in a source directory are
        # changed, created and removed until starting a build process.
        [target].flatten.inject([]) do |stack, path|
          paths = convert_source_path(path)
          (stack << OpenStruct.new(paths.merge(original: path))) if !paths.empty?
          stack
        end

      end

      def digest_of(path)
        Digest::SHA256.file(path).hexdigest
      end

      def inject_target_state
        state_skel = {created: false, removed: false, active: true, digest: ''}

        @target.each do |target|
          path_in_source = path_of target.original, :source
          path_in_build = path_of target.build, :build
          in_source = File.file? path_in_source
          in_build = File.file? path_in_build
          state = OpenStruct.new state_skel.dup

          case true
          when  in_source &&  in_build  then  # no-op               # File is updated or identical.
          when  in_source && !in_build  then  state.created = true  # File is created.
          when !in_source &&  in_build  then  state.removed = true  # File is removed.
          else                                state.active = false  # No file.
          end

          state.digest = digest_of(path_in_build) if in_build
          target.state = state
        end
      end

      def path_of(path_crumb, type, absolute = true)

        # SHOULD get path to the build|source directory at any time of need, because the
        # configuration value of :build_dir|:source can be updated anytime.
        id = type.to_sym == :build ? :build_dir : :source
        path = File.join(app.config[id], path_crumb)
        absolute ? File.expand_path(path) : path
      end

      def present_status(builder, target)
        build_path = ->(path){ path_of path, :build, false }
        message = "#{build_path.call target.build} => #{build_path.call target.expect}"

        status, message, color = \
          case true
          when target.state.created
            ['rename', "#{message} (create)", :green]
          when target.state.removed
            ['remove', "#{build_path.call target.expect}", :red]
          when target.state.active
            digest_of(path_of(target.expect, :build)) == target.state.digest \
              ? ['rename', "#{message} (identical)", :blue] \
              : ['rename', "#{message} (update)", :yellow]
          else
            ['no-target', path_of(target.original, :source, false), :magenta]
          end

        builder.say_status "EH:#{status}", message, color
      end

      def rename_build_file(from, to)
        src, dest = [path_of(from, :build), path_of(to, :build)]
        FileUtils.mv(src, dest) if File.file?(src) && !File.exist?(dest)
      end
    end
  end
end

