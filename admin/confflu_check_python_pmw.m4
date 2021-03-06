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
AC_DEFUN([CONFFLU_CHECK_PYTHON_PMW],
[
AC_CHECKING(for Python Pmw package)

AC_SUBST(ENABLE_PYTHON_PMW)

python_pmw_ok=no

dnl --------------------------------------------------------------------------------
test="python -c 'import Pmw'"

if test `eval ${test}; echo $?` = "0" ; then
   python_pmw_ok=yes
fi

echo "checking for \`${test}\`... ${python_pmw_ok}"

dnl --------------------------------------------------------------------------------
ENABLE_PYTHON_PMW=${python_pmw_ok}
])


dnl --------------------------------------------------------------------------------
