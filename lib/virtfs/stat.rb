module VirtFS
  # File Stat, contains attributes common to files on all files systems
  class Stat
    include Comparable

    # Specified File Attributes supported by VirtFS (auto converted to symbols)
    ATTR_ACCESSORS = %i(
      atime
      blksize
      blockdev?
      blocks
      chardev?
      ctime
      dev
      dev_major
      dev_minor
      directory?
      executable?
      executable_real?
      file?
      ftype
      gid
      grpowned?
      ino
      inspect
      mode
      mtime
      nlink
      owned?
      pipe?
      rdev
      rdev_major
      rdev_minor
      readable?
      readable_real?
      setgid?
      setuid?
      size
      size?
      socket?
      sticky?
      symlink?
      uid
      world_readable?
      world_writable?
      writable?
      writable_real?
      zero?
    )

    # Helper to convert attribute name to instance variable name
    #
    # @param name [String] string name
    # @return [String] string instance variable name
    def self.iv_name(name)
      name = name.to_s.chomp('?') if name.to_s.end_with?('?')
      "@#{name}"
    end

    ATTR_ACCESSORS.each { |aa| class_eval("def #{aa}; #{iv_name(aa)}; end") }

    # Attribute intializer, accepts Stat or Hash containing attributes
    #
    # @param obj [Stat,Hash] instance of object containing stat info to initialize
    def initialize(obj)
      if obj.is_a?(VfsRealFile::Stat)
        stat_init(obj)
      else
        hash_init(obj)
      end
    end

    # Sort file stats by modify time
    def <=>(other)
      return -1 if mtime < other.mtime
      return  1 if mtime > other.mtime
      0
    end

    private

    def stat_init(obj)
      ATTR_ACCESSORS.each do |aa|
        next unless obj.respond_to?(aa)
        instance_variable_set(iv_name(aa), obj.send(aa))
      end
    end

    def hash_init(obj)
      ATTR_ACCESSORS.each do |aa|
        next unless obj.key?(aa)
        instance_variable_set(iv_name(aa), obj[aa])
      end
    end

    def iv_name(name)
      self.class.iv_name(name)
    end
  end
end
