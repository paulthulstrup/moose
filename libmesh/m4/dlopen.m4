dnl ----------------------------------------------------------------------------
dnl check for a working dlopen/dlsym/dlclose implementation
dnl ----------------------------------------------------------------------------
AC_DEFUN([AX_CXX_DLOPEN],
[
  ac_cv_cxx_dlopen=no

  dnl AC_SEARCH_LIBS appends the required library to the LIBS variable if one is found
  AC_SEARCH_LIBS([dlopen], [dl dld],
    dnl action-if-found
    [
      ac_cv_cxx_dlopen=yes
    ],
    dnl action-if-not-found
    [
      ac_cv_cxx_dlopen=no
    ])

  dnl If AC_SEARCH_LIBS worked, try to compile a test code
  if (test "$ac_cv_cxx_dlopen" = yes); then
    AC_MSG_CHECKING([whether the c++ compiler supports dlopen/dlsym/dlclose])
    AC_LANG_PUSH([C++])

    AC_LINK_IFELSE([AC_LANG_PROGRAM([[
       @%:@include <stddef.h> // NULL
       @%:@include <dlfcn.h>
    ]],
    [[
       // Try all possible ways of naming libraries.  dlopen() will search
       // in system-dependent paths if these names do not contain forward
       // slashes.
       const unsigned n_names = 2;
       const char * lib_names[n_names] = {"libm.so", "libm.dylib"};

       // To catch the output of dlopen
       void * handle = NULL;

       for (unsigned i=0; i<n_names; ++i)
         {
           // Math library, surely every system has it?
           handle = dlopen(lib_names[i], RTLD_LAZY);

           if (handle)
             break;
         }

       if (!handle)
         return 1;

       // dlsym() returns the address of the code or data location
       // specified by the null-terminated character string symbol.
       void * address = dlsym(handle, "cos");

       if (!address)
         return 1;

       /* int closed_ok = */ dlclose(handle);

       return 0;
    ]])],
    dnl action-if-true
    [
      AC_MSG_RESULT(yes)
      ac_cv_cxx_dlopen=yes
    ],
    dnl action-if-false
    [
      AC_MSG_RESULT(no)
      ac_cv_cxx_dlopen=no
    ])

    AC_LANG_POP([C++])
  fi
])
