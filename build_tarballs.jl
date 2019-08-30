# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "shared-mime-info"
version = v"1.10"

sources = [
    "https://people.freedesktop.org/~hadess/shared-mime-info-1.10.tar.xz" =>
    "c625a83b4838befc8cafcd54e3619946515d9e44d63d61c4adf7f5513ddfbebf",
]

# Bash recipe for building across all platforms
# TODO: Theora and Opus once their releases are available
script = raw"""
apk add intltool
cd $WORKSPACE/srcdir
cd shared-mime-info-1.10/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, ["libsharedmime"], :libsharedmime)
]

# Dependencies that must be installed before this package can be built
# Based on http://www.linuxfromscratch.org/blfs/view/8.3/general/shared-mime-info.html
dependencies = [
# We need zlib
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.4/build_Zlib.v1.2.11.jl",
    # We need libffi
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libffi-v3.2.1-0/build_Libffi.v3.2.1.jl",
    # We need gettext
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Gettext-v0.19.8-0/build_Gettext.v0.19.8.jl",
    # We need pcre
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/PCRE-v8.42-2/build_PCRE.v8.42.0.jl",
    # We need iconv
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libiconv-v1.15-0/build_Libiconv.v1.15.0.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Glib-v2.59.0%2B0/build_Glib.v2.59.0.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/XML2-v2.9.9%2B0/build_XML2.v2.9.9.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
