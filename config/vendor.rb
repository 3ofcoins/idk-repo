archive :virtualenv,
        :url => 'http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.8.4.tar.gz',
        :version => '1.8.4' do
  FileUtils::rm_rf Dir.entries('.')-%w|.. . AUTHORS.txt LICENSE.txt README.rst|
end
