cask 'mactex' do
  version '20160603'
  sha256 '34e5c48846a674e0025e92bf1ab7bb43a1108f729b4c26c61edcda24fa5383e3'

  url "http://www.ie.u-ryukyu.ac.jp/brew/mactex-#{version}.pkg"
  name 'MacTeX'
  homepage 'https://www.tug.org/mactex/'
  license :oss

  pkg "mactex-#{version}.pkg"

  uninstall pkgutil: [
                       'org.tug.mactex.ghostscript9.19',
                       'org.tug.mactex.gui2016',
                       'org.tug.mactex.texlive2016',
                     ],
            delete:  [
                       '/usr/local/texlive/2016',
                       '/Applications/TeX',
                       '/Library/PreferencePanes/TeXDistPrefPane.prefPane',
                       '/etc/paths.d/TeX',
                       '/etc/manpaths.d/TeX',
                     ]

  zap delete: [
                '/usr/local/texlive/texmf-local',
                '~/Library/texlive/2016',
                '~/Library/Application Support/TeXShop',
                '~/Library/Application Support/TeX Live Utility',
                '~/Library/TeXShop',
              ],
      rmdir:  [
                '/usr/local/texlive',
                '~/Library/texlive',
              ]

end
