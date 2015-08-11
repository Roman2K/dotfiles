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
        when 'L' then Symlinks::HomeBased
        else raise "unknown type: %s" % type
      end.new(basedir, home, *args)
    }.tap { |installers|
      installers << Vim.new(home)
    }
  end

  module Symlinks
    class Regular
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
        FILEUTILS.mkdir_p(@to.dirname)
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

    class HomeBased < Regular
      def initialize(basedir, home, from, to)
        @name = to.to_s
        super(from, home.join(to))
      end

      attr_reader :name
    end

    class SourceLink < Regular
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
    VIM_PLUG_REPO = "https://github.com/junegunn/vim-plug"

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
      vim_plug_syml = Symlinks::Regular.new \
        "../vim-plug/plug.vim",
        @maindir.join("autoload/plug.vim")
      vim_plug_syml.install.tap do |res|
        res == :ok or return :vim_plug_syml_error
      end
      clone_vim_plug or return :vim_plug_clone_error
      install_plugins or return :plugins_install_error
      :ok
    end

    def uninstall
      dirs.each do |dir|
        FILEUTILS.rm_rf(dir)
      end
      FILEUTILS.rm_rf(@maindir.join("vim-plug"))
      FILEUTILS.rm_rf(@maindir.join("plugged"))
      if @maindir.directory? && @maindir.entries.size == 2 # ., ..
        FILEUTILS.rm_r(@maindir)
      end
      :ok
    end

  private

    def dirs
      %w(autoload swap).map { |name| @maindir.join(name) }
    end

    def clone_vim_plug
      dest = @maindir.join("vim-plug")
      !dest.directory? or return true
      system "git", "clone", VIM_PLUG_REPO, dest.to_s
    end

    def install_plugins
      system "vim", "+PlugInstall", "+qa"
    end
  end
end
