require 'fileutils'
require 'pathname'

module Dotfiles
  FILEUTILS = FileUtils
  LIST_FILENAME = "list"

  def self.with_each_installer(basedir)
    installers(basedir).each do |i|
      print "%-20s " % i.name
      res = yield i
      if res == :ok
        print "OK"
      else
        print "!! %p" % res
      end
      print "\n"
    end
  end

  def self.installers(basedir)
    basedir = Pathname(basedir)
    home    = Pathname(Dir.home)

    IO.foreach(File.join(basedir, LIST_FILENAME)).map { |line|
      type, *args = line.strip.split(" ")
      case type
        when 'S' then Symlinks::SourceLink
        when 'L' then Symlinks::Regular
        else raise "unknown type: %s" % type
      end.new(basedir, home, *args)
    }.tap { |installers|
      installers << Vim.new(home)
    }
  end

  module Symlinks
    class Basic
      def initialize(from, to)
        @from = Pathname(from)
        @to = Pathname(to)
      end

      def install
        if @to.exist?
          if valid?
            return :ok
          else
            return :destination_exists
          end
        end
        FILEUTILS.ln_s(@from, @to)
        :ok
      end

      def uninstall
        @to.exist? || @to.symlink? or return :ok
        valid? or return :other
        FILEUTILS.rm(@to)
        :ok
      end

    private

      def valid?
        path = @to.readlink
      rescue Errno::ENOENT, Errno::EINVAL
        false
      else
        [@from, @from.expand_path].include? path
      end
    end

    class Regular < Basic
      def initialize(basedir, home, from, to)
        @name = to.to_s
        super(from, home.join(to))
      end

      attr_reader :name
    end

    class SourceLink < Basic
      def initialize(basedir, home, from, to=".#{from}")
        @name = to.to_s
        super \
          basedir.join(from).cleanpath,
          home.join(to)
      end

      attr_reader :name

      def install
        @from.exist? or return :source_missing
        super
      end
    end
  end

  class Vim
    DIR = ".vim"
    VUNDLE_REPO = "https://github.com/gmarik/vundle"

    def initialize(home)
      @maindir = home.join(DIR)
    end

    def name
      @maindir.basename
    end

    def install
      dirs.each do |dir|
        FILEUTILS.mkdir_p(dir)
      end
      clone_vundle or return :vundle_clone_error
      install_bundles or return :vundle_bundle_install_error
      :ok
    end

    def uninstall
      dirs.each do |dir|
        FILEUTILS.rm_rf(dir)
      end
      if @maindir.directory? && @maindir.entries.size == 2 # ., ..
        FILEUTILS.rm_r(@maindir)
      end
      :ok
    end

  private

    def dirs
      %w(bundle swap).map { |name| @maindir.join(name) }
    end

    def clone_vundle
      dest = @maindir.join("bundle/vundle")
      !dest.directory? or return true
      system "git", "clone", VUNDLE_REPO, dest.to_s
    end

    def install_bundles
      system "vim", "+BundleInstall", "+BundleClean", "+qa"
    end
  end
end
