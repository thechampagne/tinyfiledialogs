!  _________
! /         \ tinyfiledialogs v3.10 [Mar 25, 2023] zlib licence
! |tiny file| 
! | dialogs | Copyright (c) 2014 - 2023 Guillaume Vareille http://ysengrin.com
! \____  ___/ http://tinyfiledialogs.sourceforge.net
!      \|     git clone http://git.code.sf.net/p/tinyfiledialogs/code tinyfd

! - License -
! This software is provided 'as-is', without any express or implied
! warranty.  In no event will the authors be held liable for any damages
! arising from the use of this software.
! Permission is granted to anyone to use this software for any purpose,
! including commercial applications, and to alter it and redistribute it
! freely, subject to the following restrictions:
! 1. The origin of this software must not be misrepresented; you must not
! claim that you wrote the original software.  If you use this software
! in a product, an acknowledgment in the product documentation would be
! appreciated but is not required.
! 2. Altered source versions must be plainly marked as such, and must not be
! misrepresented as being the original software.
! 3. This notice may not be removed or altered from any source distribution.


! gcc -c tinyfiledialogs.c
! gfortran -c tinyfd_module.f90 tinyfd_main.f90
! gfortran -o tinyfd_exe tinyfd_module.o foo.o tinyfd_main.o

! or in one line :  gfortran -o tinyfd_exe tinyfd_module.f90 tinyfiledialogs.c tinyfd_main.f90

! On windows, to link with the windows libraries,
! you must add: -lcomdlg32 -lole32
! and maybe: -luser32.lib -lshell32.lib

	program main
		use tinyfd
		use iso_c_binding, only: c_ptr, c_null_char, c_f_pointer, c_loc, c_null_ptr, c_associated
		implicit none
		type(c_ptr) :: cpointer
		character(128), pointer :: fpointer
		character(128) :: string, atitle, amessage	
		character(128), target :: adefaultinput

		! calling subroutine tinyfd_beep
		write(*,'(A)') "Enter tinyfd_beep()"
		call tinyfd_beep()

		! calling function tinyfd_inputbox
		write(*,'(A)') "Enter tinyfd_inputbox()"
		atitle = "a Title" // char(0)
		amessage = "a Message" // char(0)
		adefaultinput = "an Input" // char(0)

		! Get C pointer
		cpointer = tinyfd_inputbox(atitle, amessage, c_loc(adefaultinput) )
		! or for a password box:
		!cpointer = tinyfd_inputbox(atitle, amessage, c_null_ptr )

		if ( c_associated(cpointer) ) then
			! Convert C into Fortran pointer
			call c_f_pointer(cpointer, fpointer)
			! Remove NULL character at the end
			string = fpointer(1:index(fpointer,c_null_char)-1)
			write (*,'(A)') trim(string)
		endif

	end program main

