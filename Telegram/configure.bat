@echo OFF

setlocal enabledelayedexpansion
set "FullScriptPath=%~dp0"
n:: Collect original arguments
set "ORIG_ARGS=%*"
set "ARGS=%ORIG_ARGS%"
n:: If user didn't explicitly override CMAKE_MSVC_RUNTIME_LIBRARY and a Debug configuration is requested,
:: append sane defaults that match the MSVC debug runtime and enable proper exception semantics.
echo %ORIG_ARGS% | findstr /C:"CMAKE_MSVC_RUNTIME_LIBRARY" >nul
if errorlevel 1 (
  echo %ORIG_ARGS% | findstr /C:"CMAKE_CONFIGURATION_TYPES=Debug" >nul
  if not errorlevel 1 (
    set "ARGS=%ARGS% -D CMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDebugDLL -D CMAKE_CXX_FLAGS_DEBUG=/EHsc"
  )
)
n:: Call Python configurator with (possibly) augmented arguments
python "%FullScriptPath%configure.py" %ARGS%
if %errorlevel% neq 0 goto error

exit /b 0

:error
echo FAILED
exit /b 1
