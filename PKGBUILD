# Maintainer: crimsonote <crimsonote@outlook.com>
# Contributor: Felix Golatofski <contact@xdfr.de>
# Contributor: Andy Weidenbaum <archbaum@gmail.com>
# Contributor: Sebastian Lau <archlinux _at_ slau _dot_ info>
# Contributor: Eric Ozwigh <ozwigh at gmail dot com>
pkgname=veracrypt-trans
_pkgname=VeraCrypt
pkgver=1.24_Update4
pkgrel=1
pkgdesc='Disk encryption with strong security based on TrueCrypt.Translate the interface to other languages. (The language cannot be changed after compilation)'
url='https://www.veracrypt.fr/'
arch=('i686' 'x86_64')
license=('custom:TrueCrypt')
depends=('fuse2>=2.8.0' 'wxgtk3>=3.0' 'libsm' 'device-mapper')
optdepends=('sudo: mounting encrypted volumes as nonroot users')
makedepends=('git' 'yasm' 'libxml2' 'coreutils' )
source=("${_pkgname}_${pkgver//_/-}.tar.gz::https://github.com/veracrypt/VeraCrypt/archive/${_pkgname}_${pkgver//_/-}.tar.gz"
	no-makeself.patch
        veracrypt.desktop)
sha512sums=('e077d6fe6a35234737387c4a6997399a251e238ab75524f53efe8ed742a35164fa4d5fcb0f15816dcb29d31fb8a4bb175d45b9aefb912c4747194fb320fa408d'
            '40c269859bb97fbcceb443e5f457788bac650271ed118ec79d34f56fc340ad6e613114fe905ec5aba8c4d171c51c9a6865f97e9fa1ba01fa98ef18be4e97bbe1'
            'f689ca64bac7042030de7714aed8cc89f2c5f87b407444b1b121491c1d89c147babaaa454ddc2a93b70ae20d4da59f96ad64f01b04bea9017d658c377faeb75d')
provides=('veracrypt')
conflicts=('veracrypt' 'veracrypt-git')

#pkgver() {
#  cd $srcdir/${_pkgname}-${_pkgname}_${pkgver//_/-}
#  git log -1 --format="%cd" --date=short --no-show-signature | tr -d '-'
#}

prepare() {
  #cd $srcdir/${pkgname%-trans}/src
  cd $srcdir/${_pkgname}-${_pkgname}_${pkgver//_/-}/src

  chmod -R u+w . # WAT award
  patch -Np1 < "${srcdir}/no-makeself.patch"
}

build() {
#  cd $srcdir/${pkgname%-trans}

  cd $srcdir/${_pkgname}-${_pkgname}_${pkgver//_/-}
  [ -f "/tmp/aur_veracrypt.log" ]&&rm /tmp/aur_veracrypt.log
  cp $srcdir/../Translations/attach-language.*.xml Translations/
  bash $srcdir/../trans-edit.sh true 
  cd src
  make PKG_CONFIG_PATH=/usr/lib/pkgconfig \
    WX_CONFIG=/usr/bin/wx-config-gtk3 \
    TC_EXTRA_LFLAGS+="-ldl ${LDFLAGS}" \
    TC_EXTRA_CXXFLAGS="${CXXFLAGS} ${CPPFLAGS}" \
    TC_EXTRA_CFLAGS="${CFLAGS} ${CPPFLAGS}"\
    CC="clang" \
    CXX="clang++"
}

package() {
  #  cd $srcdir/${pkgname%-trans}/src
  cd $srcdir/${_pkgname}-${_pkgname}_${pkgver//_/-}/src
  pwd
  install -Dm 755 Main/${pkgname%-trans} "${pkgdir}/usr/bin/${pkgname%-trans}"
  install -Dm 644 "${srcdir}/veracrypt.desktop" -t "${pkgdir}/usr/share/applications"
  install -Dm 644 Resources/Icons/VeraCrypt-256x256.xpm "${pkgdir}/usr/share/pixmaps/veracrypt.xpm"
  install -Dm 644 License.txt -t "${pkgdir}/usr/share/licenses/${pkgname%-trans}"
}
