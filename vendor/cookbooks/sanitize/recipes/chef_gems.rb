node['sanitize']['chef_gems'].each do |name, attrs|
  attrs = { 'version' => attrs } unless attrs.is_a?(Hash)
  next unless attrs.fetch('version', true) # if it's explicitly set to false, don't install

  chef_gem name do
    version attrs['version'] if attrs['version'].is_a?(String)
  end
  require attrs.fetch('require', name) if attrs.fetch('require', true)
end
