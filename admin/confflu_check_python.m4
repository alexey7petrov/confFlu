dnl confFlu - pythonFlu configuration package
dnl Copyright (C) 2010- Alexey Petrov
dnl Copyright (C) 2009-2010 Pebble Bed Modular Reactor (Pty) Limited (PBMR)
dnl 
dnl This program is free software: you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation, either version 3 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl 
dnl You should have received a copy of the GNU General Public License
dnl along with this program.  If not, see <http://www.gnu.org/licenses/>.
dnl 
dnl See http://sourceforge.net/projects/pythonflu
dnl
dnl Author : Alexey PETROV
dnl


dnl --------------------------------------------------------------------------------
AC_DEFUN([CONFFLU_CHECK_PYTHON],dnl
[
echo "--------------------------------------------------------------------------------------"
AC_CHECKING(for Python environemnt)

AC_REQUIRE([CONFFLU_CHECK_OS])

AC_LANG_SAVE
AC_LANG_CPLUSPLUS
STORE_CPPFLAGS=${CPPFLAGS}
STORE_CXXFLAGS=${CXXFLAGS}
STORE_LDFLAGS=${LDFLAGS}

PYTHON_CPPFLAGS=""
AC_SUBST(PYTHON_CPPFLAGS)

PYTHON_CXXFLAGS=""
AC_SUBST(PYTHON_CXXFLAGS)

PYTHON_LDFLAGS=""
AC_SUBST(PYTHON_LDFLAGS)

dnl --------------------------------------------------------------------------------
python_ok=yes
AC_SUBST(python_ok)

PYTHON_VERSION=""

AC_SUBST(PYTHON_VERSION)

PYTHONDIR=""

AC_SUBST(PYTHONDIR)

AC_CHECK_PROG( [python_ok], [python], [yes], [no] )

if test "x${python_ok}" = "xno" ; then
   AC_MSG_ERROR( [Python need to be installed to continue] )
fi

python_version=[`python -c "import sys; print sys.version[:3]"`]

PYTHON_VERSION=${python_version}

python_app=`which python`
python_app_dir=`dirname ${python_app}`
python_home=`(cd ${python_app_dir}/..; pwd)`

dnl --------------------------------------------------------------------------------
python_includes_ok=no
AC_ARG_WITH( [python_includes],
             AC_HELP_STRING( [--with-python-includes=<path>],
                             [use <path> to look for Python includes] ),
             [],
             [ with_python_includes=no ] )

if test "x${with_python_includes}" = "xno" ; then
   with_python_includes=${python_home}/include/python${python_version}
   AC_CHECK_FILE( [${with_python_includes}/Python.h], [ python_includes_ok=yes ], [ python_includes_ok=no ] )
fi

if test "x${python_includes_ok}" = "xno" ; then
   with_python_includes=/usr/include/python${python_version}
   AC_CHECK_FILE( [${with_python_includes}/Python.h], [ python_includes_ok=yes ], [ python_includes_ok=no ] )
fi

if test "x${python_includes_ok}" = "xyes" ; then
   PYTHON_CPPFLAGS="-I${with_python_includes}"
   CPPFLAGS="${PYTHON_CPPFLAGS}"

   AC_CHECK_HEADERS( [Python.h], [ python_includes_ok=yes ], [ python_includes_ok=no ] )
fi

if test "x${python_includes_ok}" = "xno" ; then
   AC_MSG_ERROR( [python-dev need to be installed or use --with-python-includes=<path> to define Python header files location] )
fi


dnl --------------------------------------------------------------------------------
python_libraries_ok=no
AC_ARG_WITH( [python_libraries],
             AC_HELP_STRING( [--with-python-libraries=<path>],
                             [use <path> to look for Python libraries] ),
             [],
             [ with_python_libraries=no ]  )
   
if test "x${with_python_libraries}" = "xno" ; then
   with_python_libraries=${python_home}/lib
   AC_CHECK_FILE( [${with_python_libraries}/libpython${python_version}.so], [ python_libraries_ok=yes ], [ python_libraries_ok=no ] )
fi

if test "x${python_libraries_ok}" = "xno" ; then
   with_python_libraries=/usr/lib
   AC_CHECK_FILE( [${with_python_libraries}/libpython${python_version}.so], [ python_libraries_ok=yes ], [ python_libraries_ok=no ] )
fi

if test "x${python_libraries_ok}" = "xno" ; then
   with_python_libraries=/usr/lib64
   AC_CHECK_FILE( [${with_python_libraries}/libpython${python_version}.so], [ python_libraries_ok=yes ], [ python_libraries_ok=no ] )
fi

dnl checking path from --with-python-libraries=<path>
if test "x${python_libraries_ok}" = "xno" ; then
   AC_CHECK_FILE( [${with_python_libraries}/libpython${python_version}.so], [ python_libraries_ok=yes ], [ python_libraries_ok=no ] )
fi


if test "x${python_libraries_ok}" = "xyes" ; then
   PYTHON_CXXFLAGS=""
   CXXFLAGS="${PYTHON_CXXFLAGS}"

   PYTHON_LDFLAGS="-lpython${python_version}"
   test ! "x${with_python_libraries}" = "x/usr/lib" && PYTHON_LDFLAGS="-L${with_python_libraries} ${PYTHON_LDFLAGS}"
   LDFLAGS=${PYTHON_LDFLAGS}

   AC_MSG_CHECKING( for linking to Python libraries )
   AC_LINK_IFELSE( [ AC_LANG_PROGRAM( [ #include <Python.h> ], [ PyDict_New() ] ) ],
                   [ python_libraries_ok=yes ],
                   [ python_libraries_ok=no ] )
   AC_MSG_RESULT( ${python_libraries_ok} )
fi

if test "x${python_libraries_ok}" = "xno" ; then
   AC_MSG_ERROR( [python-dev need to be installed or use --with-python-libraries=<path> to define Python libraries location] )
fi

AC_MSG_NOTICE( @PYTHON_VERSION@ == "${PYTHON_VERSION}" )


dnl --------------------------------------------------------------------------------
AC_ARG_WITH( [pythondir],
             AC_HELP_STRING( [--with-pythondir=<path>],
                             [ <path> to install Python modules] ),
             [],
             [ with_pythondir=`python -c  "from distutils.sysconfig import get_python_lib; print get_python_lib()" 2>/dev/null` ]  )

if test "x${with_pythondir}" = "x"; then
  if test "${OS_NAME}" == "Ubuntu"; then
     with_pythondir=/usr/local/lib/python${PYTHON_VERSION}/dist-packages
  fi
  
  if test "${OS_NAME}" == "openSUSE"; then
     with_pythondir=/usr/local/lib/python${PYTHON_VERSION}/site-packages
  fi

  if test "x${OS_NAME}" == "x"; then
     AC_MSG_ERROR( [python-setuptools need to be installed or use --with-pythondir=<path> where to install Python Modules] )
  fi
fi

PYTHONDIR=${with_pythondir}

AC_MSG_NOTICE( @PYTHONDIR@ == "${PYTHONDIR}" )


dnl --------------------------------------------------------------------------------
AC_LANG_RESTORE
CPPFLAGS=${STORE_CPPFLAGS}
CXXFLAGS=${STORE_CXXFLAGS}
LDFLAGS=${STORE_LDFLAGS}
])


dnl --------------------------------------------------------------------------------
