# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Library used to create an internal representation of an API in order to create Python bindings"
HOMEPAGE="http://www.pyside.org/"
EGIT_REPO_URI="git://gitorious.org/pyside/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND=">=dev-libs/boost-1.41.0[python]
	dev-libs/libxml2
	dev-libs/libxslt
	>=x11-libs/qt-core-4.5.0
	>=x11-libs/qt-xmlpatterns-4.5.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}"

DOCS=(AUTHORS)

src_prepare() {
	sed -e 's:share/cmake-2.6/Modules:share/cmake/Modules:' \
		-e '/^install/s/lib/lib${LIB_SUFFIX}/' \
		-i "${S}/CMakeLists.txt" || die "sed failed"
}
