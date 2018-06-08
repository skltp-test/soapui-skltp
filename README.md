# soapui-skltp

# Preparations:
# - 'soapui-settings.xml' needs to be in place for the user before test execution (SSL settings)

# Run from command line
/opt/soapui/bin/testrunner.sh -s "Ursprunglig avsändare" -c "1.1.1 - Angränsande konsument skickar fråga via aggregerande tjänst" -A -r -j -M -f `pwd`/result -I `pwd`/NTjP-RT-soapui-project.xml

