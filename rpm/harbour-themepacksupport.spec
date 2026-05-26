Name:           harbour-themepacksupport
Version:        0.8.13
Release:        4
Summary:        Theme pack support
Obsoletes:      harbour-iconpacksupport <= 0.0.4-4
Conflicts:      harbour-iconpacksupport
Group:          System/Tools
Vendor:         fravaccaro
Distribution:   SailfishOS
Requires:       sailfish-version >= 2.1.4, rsync
BuildArch:      noarch
Packager:       fravaccaro <fravaccaro@jollacommunity.it>
License:        GPLv3
URL:            https://github.com/uithemer/themepacksupport-sailfishos

%description
Theme pack support for Sailfish OS

%install
rm -rf %{buildroot}

# 1. Create all necessary directory structures
mkdir -p %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/icons/hicolor/86x86/apps
mkdir -p %{buildroot}/etc/systemd/system/aliendalvik.service.d
mkdir -p %{buildroot}/lib/systemd/system
mkdir -p %{buildroot}/etc/systemd/system

# 2. Copy the main scripts/files to the data directory
# This assumes your source folder has these files/folders
cp -r harbour-themepacksupport/usr/share/harbour-themepacksupport/* %{buildroot}%{_datadir}/%{name}/

# 3. Move specific files to their system locations in the build root
mv %{buildroot}%{_datadir}/%{name}/themepacksupport.sh %{buildroot}%{_bindir}/themepacksupport
mv %{buildroot}%{_datadir}/%{name}/%{name}.desktop %{buildroot}%{_datadir}/applications/
mv %{buildroot}%{_datadir}/%{name}/%{name}.png %{buildroot}%{_datadir}/icons/hicolor/86x86/apps/
mv %{buildroot}%{_datadir}/%{name}/service/10-themepacksupport.conf %{buildroot}/etc/systemd/system/aliendalvik.service.d/
mv %{buildroot}%{_datadir}/%{name}/service/themepacksupport-systemupgrade.service %{buildroot}/lib/systemd/system/
mv %{buildroot}%{_datadir}/%{name}/service/themepacksupport-autoupdate.service %{buildroot}/etc/systemd/system/
mv %{buildroot}%{_datadir}/%{name}/service/themepacksupport-autoupdate.timer %{buildroot}/etc/systemd/system/

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_bindir}/themepacksupport
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
/etc/systemd/system/aliendalvik.service.d/10-themepacksupport.conf
/lib/systemd/system/themepacksupport-systemupgrade.service
/etc/systemd/system/themepacksupport-autoupdate.service
/etc/systemd/system/themepacksupport-autoupdate.timer

%post
# Set permissions
chmod +x %{_datadir}/%{name}/*.sh
chmod +x %{_datadir}/%{name}/service/*.sh

# Create necessary directories
mkdir -p %{_datadir}/%{name}/backup
mkdir -p %{_datadir}/%{name}/tmp
mkdir -p /home/defaultuser/.themepack

systemctl daemon-reload
systemctl enable themepacksupport-systemupgrade.service

# Initialize state files
touch -a %{_datadir}/%{name}/icon-current
touch -a %{_datadir}/%{name}/font-current
touch -a %{_datadir}/%{name}/sound-current
touch -a %{_datadir}/%{name}/graphic-current
touch -a %{_datadir}/%{name}/droiddpi-current

# Save the model in a file
ssu mo | sed 's/.*: //' > %{_datadir}/%{name}/device-model

# If UI Themer is installed, keep the icon hidden
if [ -d %{_datadir}/sailfishos-uithemer ]; then
    echo "NoDisplay=true" >> %{_datadir}/applications/%{name}.desktop
fi

%preun
if [ $1 = 0 ]; then
    # Uninstallation
    systemctl disable themepacksupport-systemupgrade.service
    %{_datadir}/%{name}/disable-autoupdate.sh
    %{_datadir}/%{name}/icon-restore.sh
    %{_datadir}/%{name}/graphic-restore.sh
    %{_datadir}/%{name}/font-restore.sh
    %{_datadir}/%{name}/sound-restore.sh
    %{_datadir}/%{name}/restore_dpr.sh
    %{_datadir}/%{name}/restore_adpi.sh
    %{_datadir}/%{name}/restore_iz.sh
    %{_datadir}/%{name}/disable-dpi.sh
fi

%postun
if [ $1 = 0 ]; then
    # Clean up created directories
    rm -rf /home/defaultuser/.themepack
    systemctl daemon-reload
fi

%changelog
* Sat Aug 24 2019 0.8.13
- Improved autoupd script.
