# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython 2.7-pypy-*"
PYTHON_EXPORT_PHASE_FUNCTIONS="1"

EHG_REPO_URI="http://www.riverbankcomputing.com/hg/sip"
[[ ${PV} == *9999* ]] && HG_ECLASS="mercurial"

inherit eutils python toolchain-funcs ${HG_ECLASS}

HG_REVISION=fdc332e116b2

DESCRIPTION="Python extension module generator for C and C++ libraries"
HOMEPAGE="http://www.riverbankcomputing.co.uk/software/sip/intro http://pypi.python.org/pypi/SIP"
LICENSE="|| ( GPL-2 GPL-3 sip )"

# Subslot based on SIP_API_MAJOR_NR from siplib/sip.h.in
SLOT="0/9"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="debug doc"

DEPEND=""
RDEPEND=""

if [[ ${PV} == *9999* ]]; then
	# live version from mercurial repo
	DEPEND="${DEPEND}
		sys-devel/bison
		sys-devel/flex"
	S=${WORKDIR}/${PN}
elif [[ ${PV} == *_pre* ]]; then
	# development snapshot
	MY_P=${PN}-${PV%_pre*}-snapshot-${HG_REVISION}
	SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${MY_P}.tar.gz"
	S=${WORKDIR}/${MY_P}
fi

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.9.3-darwin.patch
	sed -i -e 's/-O2//g' specs/* || die

	if [[ ${PV} == *9999* ]]; then
		$(PYTHON -2) build.py prepare || die
	fi

	python_src_prepare
}

src_configure() {
	configuration() {
		local myconf=("$(PYTHON)"
			configure.py
			--bindir="${EPREFIX}/usr/bin"
			--destdir="${EPREFIX}$(python_get_sitedir)"
			--incdir="${EPREFIX}$(python_get_includedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			$(use debug && echo --debug)
			CC="$(tc-getCC)"
			CXX="$(tc-getCXX)"
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			CFLAGS="${CFLAGS}"
			CXXFLAGS="${CXXFLAGS}"
			LFLAGS="${LDFLAGS}"
			STRIP=":")
		echo "${myconf[@]}"
		"${myconf[@]}"
	}
	python_execute_function -s configuration
}

src_install() {
	python_src_install

	dodoc NEWS

	if use doc; then
		dohtml -r doc/html/*
	fi
}

pkg_postinst() {
	python_mod_optimize sipconfig.py sipdistutils.py
}

pkg_postrm() {
	python_mod_cleanup sipconfig.py sipdistutils.py
}