# Partly stolen from:
# https://jonasdevlieghere.com/a-better-youcompleteme-config/
from os import walk, path as os_path, name as os_name
from logging import info
from ycm_core import CompilationDatabase

BASE_FLAGS = [
    '-Wall', '-Wextra', '-Werror', '-Wno-long-long', '-Wno-variadic-macros',
    '-fexceptions', '-std=c++11', '-xc++', '-I', '-I.', 'include',
    '-I/usr/lib/', '-I/usr/include/'
]

# Partly taken from: https://github.com/Valloric/YouCompleteMe/issues/1932
if os_name == 'nt':
    BASE_FLAGS = [
        '-std=c++11', '-x', 'c++',
        '-I', 'C:/Program Files/Microsoft Visual Studio 14.0/VC/include',
        '-I', 'C:/Program Files/Windows Kits/8.1/Include/um',
        '-I', 'C:/Program Files/Windows Kits/8.1/Include/shared',
        '-I', 'C:/Program Files/Windows Kits/8.1/Include/winrt',
        '-I', 'C:/Program Files/Windows Kits/10/Include/10.0.10240.0/ucrt'
        '--target', 'i686-pc-windows-msvc19.00.24210',
        '/link', '/LIBPATH:"C:\Program Files\Microsoft Visual Studio 14.0\VC\lib"',
        '/EHsc']


SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']
HEADER_EXTENSIONS = ['.h', '.hxx', '.hpp', '.hh']


def IsHeaderFile(filename):
    extension = os_path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS


def GetCompilationInfoForFile(database, filename):
    if IsHeaderFile(filename):
        basename = os_path.splitext(filename)[0]
        for extension in SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os_path.exists(replacement_file):
                compilation_info = database.GetCompilationInfoForFile(
                    replacement_file)
                if compilation_info.compiler_flags_:
                    return compilation_info
        return None
    return database.GetCompilationInfoForFile(filename)


def FindNearest(path, target, build_folder):
    candidate = os_path.join(path, target)
    if (os_path.isfile(candidate) or os_path.isdir(candidate)):
        info("Found nearest " + target + " at " + candidate)
        return candidate

    parent = os_path.dirname(os_path.abspath(path))
    if (parent == path):
        raise RuntimeError("Could not find " + target)

    if (build_folder):
        # possible suffixes are _linux, _mac, _win (e.g. build_linux)
        for suffix in ["_linux", "_mac", "_win"]:
            candidate = os_path.join(parent, build_folder + suffix, target)
            if (os_path.isfile(candidate) or os_path.isdir(candidate)):
                info("Found nearest " + target + " in build folder at " +
                    candidate)
                return candidate

    return FindNearest(parent, target, build_folder)


def MakeRelativePathsInFlagsAbsolute(flags, working_directory):
    if not working_directory:
        return list(flags)
    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os_path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os_path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForInclude(root):
    try:
        include_path = FindNearest(root, 'include')
        flags = []
        for dirroot, dirnames, filenames in walk(include_path):
            for dir_path in dirnames:
                real_path = os_path.join(dirroot, dir_path)
                flags = flags + ["-I" + real_path]
        return flags
    except:
        return None


def FlagsForCompilationDatabase(root, filename):
    try:
        # Last argument of next function is the name of the build folder for
        # out of source projects
        compilation_db_path = FindNearest(root, 'compile_commands.json',
                                          'build')
        compilation_db_dir = os_path.dirname(compilation_db_path)
        info("Set compilation database directory to " + compilation_db_dir)
        compilation_db = CompilationDatabase(compilation_db_dir)
        if not compilation_db:
            info("Compilation database file found but unable to load")
            return None
        compilation_info = GetCompilationInfoForFile(compilation_db, filename)
        if not compilation_info:
            info("No compilation info for " + filename +
                 " in compilation database")
            return None
        return MakeRelativePathsInFlagsAbsolute(
            compilation_info.compiler_flags_,
            compilation_info.compiler_working_dir_)
    except:
        return None


def FlagsForFile(filename):
    root = os_path.realpath(filename)
    compilation_db_flags = FlagsForCompilationDatabase(root, filename)
    if compilation_db_flags:
        final_flags = compilation_db_flags
    else:
        final_flags = BASE_FLAGS
        include_flags = FlagsForInclude(root)
        if include_flags:
            final_flags = final_flags + include_flags
    return {'flags': final_flags, 'do_cache': True}
