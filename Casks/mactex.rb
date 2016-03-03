cask 'mactex' do
  version '20150613'
  sha256 'c5f5b0fd853a17dab6e844fb5e893804af78d938fa18ee94ec3b257611a95c12'

  # ctan.org is the official download host per the vendor homepage
  # http://mirror.ctan.org/systems/mac/mactex/mactex-#{version}.pkg
  # cached by ie
  url "http://www.ie.u-ryukyu.ac.jp/brew/MacTex.pkg"
  name 'MacTeX'
  homepage 'http://www.tug.org/mactex/'
  license :oss

  pkg "MacTex.pkg"

  uninstall :pkgutil => [
                         'org.tug.mactex.ghostscript9.10',
                         'org.tug.mactex.gui2014',
                         'org.tug.mactex.texlive2014'
                        ],
            :delete  => [
                         '/Applications/TeX',
                         '/Library/PreferencePanes/TeXDistPrefPane.prefPane',
                         '/etc/paths.d/TeX',
                         '/etc/manpaths.d/TeX',
                        ]
end
