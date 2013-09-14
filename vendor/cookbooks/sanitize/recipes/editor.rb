# Sane editor
# ===========

package "vim-nox"

execute "update-alternatives --set editor /usr/bin/vim.nox" do
  not_if "update-alternatives --query editor |grep -q '^Value: /usr/bin/vim.nox$'"
end
