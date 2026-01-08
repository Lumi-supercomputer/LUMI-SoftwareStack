wget https://files.pythonhosted.org/packages/0b/2c/87f3254fd8ffd29e4c02732eee68a83a1d3c346ae39bc6822dcbcb697f2b/wheel-0.45.1-py3-none-any.whl
PYTHONPATH=$workdir/easybuild/lib/python3.11/site-packages:$PYTHONPATH
pip3.11 install i--prefix=$workdir/easybuild wheel-0.45.1-py3-none-any.whl

cd easybuild_framework-5.1.2
pip3.11 install --prefix=$workdir/easybuild --no-build-isolation .
cd ../easybuild_easyblocks-5.1.2/
pip3.11 install --prefix=$workdir/easybuild --no-build-isolation .

