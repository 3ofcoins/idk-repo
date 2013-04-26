# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

require 'minigit'
require 'pathname'

class DocumentationDataSource < Nanoc::DataSources::FilesystemUnified
  identifier :documentation

  def items
    load_objects(@config[:source_path], 'item', Nanoc::Item)
  end

  def all_files_in(dir_name)
    _root    = Pathname.new('/')
    _source  = Pathname.new(@config[:source_path]).expand_path
    _ignored = @config[:ignore].
      map { |ignored| ignored =~ /^[.\/]/ ? ignored : "**/#{ignored}" }
    MiniGit::Capturing.ls_files(dir_name).lines.map(&:strip).reject do |path|
      _ignored.any? do |pat|
        _root.join(Pathname.new(path).expand_path.relative_path_from(_source)).fnmatch?(pat)
      end
    end
  end
end
