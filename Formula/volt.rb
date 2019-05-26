class Volt < Formula
  desc "Meta-level vim package manager"
  homepage "https://github.com/vim-volt/volt"
  url "https://github.com/vim-volt/volt.git",
    :tag      => "v0.3.7",
    :revision => "e604467d8b440c89793b2e113cd241915e431bf9"
  head "https://github.com/vim-volt/volt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a92d0efdad62f219c3c1418fea24d63866cdfdeee636619c404b925ab895019b" => :mojave
    sha256 "2d0f635d811c76d93c6be599f850cf1036164e6abc4b032d2a787b8fc8603ce2" => :high_sierra
    sha256 "795b36fa36d4b257a32e7eb80d004677eb3a8f007f221b63be31df3663c17c00" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/vim-volt/volt").install buildpath.children
    cd "src/github.com/vim-volt/volt" do
      system "go", "build", "-o", bin/"volt"
      prefix.install_metafiles

      bash_completion.install "_contrib/completion/bash" => "volt"
      zsh_completion.install "_contrib/completion/zsh" => "_volt"
      cp "#{bash_completion}/volt", "#{zsh_completion}/volt-completion.bash"
    end
  end

  test do
    mkdir_p testpath/"volt/repos/localhost/foo/bar/plugin"
    File.write(testpath/"volt/repos/localhost/foo/bar/plugin/baz.vim", "qux")
    system bin/"volt", "get", "localhost/foo/bar"
    assert_equal File.read(testpath/".vim/pack/volt/opt/localhost_foo_bar/plugin/baz.vim"), "qux"
  end
end
