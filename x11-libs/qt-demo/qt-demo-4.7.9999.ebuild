# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit qt4-build-edge

DESCRIPTION="Demonstration module of the Qt toolkit"
SLOT="4"
KEYWORDS=""
IUSE="qt3support"

DEPEND="~x11-libs/qt-assistant-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-core-${PV}:${SLOT}[stable-branch=,qt3support=]
	~x11-libs/qt-dbus-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-gui-${PV}:${SLOT}[stable-branch=,qt3support]
	~x11-libs/qt-declarative-${PV}:${SLOT}[stable-branch=,webkit]
	~x11-libs/qt-multimedia-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-opengl-${PV}:${SLOT}[stable-branch=,qt3support=]
	|| ( ~x11-libs/qt-phonon-${PV}:${SLOT}[stable-branch=] media-libs/phonon )
	~x11-libs/qt-script-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-sql-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-svg-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-test-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-webkit-${PV}:${SLOT}[stable-branch=]
	~x11-libs/qt-xmlpatterns-${PV}:${SLOT}[stable-branch=]"
RDEPEND="${DEPEND}"

pkg_setup() {
	QT4_TARGET_DIRECTORIES="demos
		examples"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		doc/src/images
		src/
		include/
		tools/"

	qt4-build-edge_pkg_setup
}

src_configure() {
	myconf="${myconf} $(qt_use qt3support)"
	qt4-build-edge_src_configure
}

src_install() {
	insinto ${QTDOCDIR}/src
	doins -r "${S}"/doc/src/images || die

	qt4-build-edge_src_install
}
