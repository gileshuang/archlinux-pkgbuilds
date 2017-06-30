# $Id$
# Maintainer: Felix Yan <felixonmars@archlinux.org>
# Contributor: Josip Ponjavic <josipponjavic at gmail dot com>
# Contributor: Xu Fasheng <fasheng.xu[AT]gmail.com>

pkgname=deepin-screenshot-fork
pkgver=4.0.8
pkgrel=1
pkgdesc="Easy-to-use screenshot tool for linuxdeepin desktop environment"
arch=('i686' 'x86_64')
url="https://github.com/linuxdeepin/deepin-screenshot"
license=('GPL3')
provides=('deepin-screenshot')
depends=('deepin-tool-kit')
makedepends=('qt5-tools')
groups=('deepin-extra')
source=(deepin-screenshot::git+https://github.com/alienhjy/deepin-screenshot.git)
sha512sums=('SKIP')

build() {
  cd deepin-screenshot
  qmake-qt5 PREFIX=/usr
  make
}

package() {
  cd deepin-screenshot
  make INSTALL_ROOT="$pkgdir" install
}
