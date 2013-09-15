# FIXME: this should be refactored.
class << chef_berkshelf
  def conjure!
    FileUtils.cp_r File.join(environment.git.git_work_tree, 'cookbooks'),
                   File.join(git.git_work_tree, 'cookbooks')
    super

    site_cookbooks =
      Dir[ File.join(environment.git.git_work_tree, 'cookbooks/*/metadata.rb') ].
      map { |metadata_path| File.basename(File.dirname(metadata_path)) }
    site_cookbooks << File.join(git.git_work_tree, 'cookbooks')
    FileUtils.rm_rf site_cookbooks, verbose: true
  end
end
