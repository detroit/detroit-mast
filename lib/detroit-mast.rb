require 'detroit/tool'

module Detroit

  # Mast Tool
  #
  class Mast < Tool

    # Default MANIFEST filename.
    DEFAULT_FILENAME = 'MANIFEST'

    # Default files/dirs to include.
    DEFAULT_INCLUDE = %w{ bin data etc features lib man meta qed script spec test [A-Z]* }

    # Default files/dirs to exclude.
    DEFAULT_EXCLUDE = nil #%w{}

    # Default files/dirs to ignore. Unlike exclude, this work
    # on path basenames, and not full pathnames.
    DEFAULT_IGNORE = nil #%w{}

    # Not that this is necessary, but ...
    #def self.available?(project)
    #  begin
    #    require 'mast'
    #    true
    #  rescue LoadError
    #    false
    #  end
    #end

    #
    attr_accessor :include

    #
    attr_accessor :exclude

    #
    attr_accessor :ignore

    #
    attr_accessor :output

    #
    #def output=(path)
    #  @output = Pathname.new(path)
    #end

    #  A S S E M B L Y  M E T H O D S

    def assemble?(station, options={})
      case station
      when :pre_generate then true
      end
    end

    # It's important to update the manifest before other generators, so
    # this plugs into the :pre_generate phase.
    def assemble(station, options={})
      case station
      when :pre_generate then generate
      end
    end

    #
    def manifest
      @manifest ||= ::Mast::Manifest.new(options)
    end

    # Generate manifest.
    # TODO: don't overwrite if it hasn't changed
    def generate
      if !file #manifest.exist? (future version of mast)
        file = manifest.save
        report "Created #{file.to_s.sub(Dir.pwd+'/','')}"
      elsif manifest.changed?
        file = manifest.update
        report "Updated #{file.to_s.sub(Dir.pwd+'/','')}"
        #report "Updated #{output.to_s.sub(Dir.pwd+'/','')}"
      else
        report "#{output.to_s.sub(Dir.pwd+'/','')} is current"
      end
    end

    # Mark MANIFEST as out-of-date.
    # TODO: Implement reset.
    #def reset
    #end

    # Remove MANIFEST.
    # TODO: Currently a noop. Not sure removing manfest is ever a good idea.
    #def clean
    #end

  private

    #
    def initialize_requires
      require 'mast'
    end

    #
    def initialize_defaults
      @include = DEFAULT_INCLUDE
      @exclude = DEFAULT_EXCLUDE
      @ignore  = DEFAULT_IGNORE
      @output  = (file || project.root + DEFAULT_FILENAME).to_s
    end

    #
    def file
      project.root.glob("MANIFEST{,.txt}", File::FNM_CASEFOLD).first
    end

    #
    def options
      { :include => include,
        :exclude => exclude,
        :ignore  => ignore,
        :file    => output
      }
    end

  end

end

