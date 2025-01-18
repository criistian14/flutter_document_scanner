@echo off
echo Setting up Git hooks...

if exist .git\hooks (
    rmdir .git\hooks /s /q
)

mklink /D .git\hooks ..\hooks

echo Git hooks have been set up successfully!
