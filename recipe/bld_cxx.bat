mkdir build
cd build

cmake %CMAKE_ARGS% ^
    -G "Ninja" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    -DHUMANSTATEPROVIDER_ENABLE_LOGGER:BOOL=ON ^
    -DHUMANSTATEPROVIDER_ENABLE_VISUALIZER:BOOL=ON ^
    -DXSENS_MVN_USE_SDK:BOOL=OFF ^
    -DENABLE_XsensSuit:BOOL=OFF ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

setlocal EnableDelayedExpansion
:: Generate and copy the [de]activate scripts to %PREFIX%\etc\conda\[de]activate.d.
:: This will allow them to be run on environment activation.
for %%F in (activate deactivate) DO (
    multisheller %RECIPE_DIR%\%%F.msh --output .\%%F

    if not exist %PREFIX%\etc\conda\%%F.d mkdir %PREFIX%\etc\conda\%%F.d
    copy %%F.bat %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bat
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.sh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.sh
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.bash %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.bash
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.ps1 %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.ps1
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.xsh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.xsh
    if %errorlevel% neq 0 exit /b %errorlevel%

    copy %%F.zsh %PREFIX%\etc\conda\%%F.d\%PKG_NAME%_%%F.zsh
    if %errorlevel% neq 0 exit /b %errorlevel%
)
