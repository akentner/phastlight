if [ $# -lt 1 ]
then
  dir=/usr/local/phastlight
else
  dir=$1
fi

mkdir $dir
cd $dir

# Download php src and enable sockets extension
if [ ! -f php-5.4.6.tar.gz ];
then
  wget http://us2.php.net/get/php-5.4.6.tar.gz/from/this/mirror
fi
tar xvf php-5.4.6.tar.gz
cd php-5.4.6
./configure --enable-sockets --prefix=$dir
make
make install
cd ..

# Install php-uv
export CFLAGS='-fPIC' 
git clone https://github.com/chobie/php-uv.git --recursive
cd php-uv/libuv
make && cp uv.a libuv.a
cd ..
phpize
./configure --with-php-config=$dir/bin/php-config
make && make install

# Install httpparser
git clone https://github.com/chobie/php-httpparser.git --recursive
cd php-httpparser
phpize
./configure --with-php-config=$dir/bin/php-config
make && make install

cd $dir

# write php.ini file
echo -e "extension_dir="$dir"/lib/php/extensions/no-debug-non-zts-20100525\n" > php.ini
echo -e "extension=uv.so\nextension=httpparser.so" >> php.ini
