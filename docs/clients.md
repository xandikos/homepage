# Tested Clients

Xandikos has been tested and works with the following CalDAV/CardDAV clients:

- [Vdirsyncer](https://github.com/pimutils/vdirsyncer)
- [caldavzap](https://www.inf-it.com/open-source/clients/caldavzap/)/[carddavmate](https://www.inf-it.com/open-source/clients/carddavmate/)
- [evolution](https://wiki.gnome.org/Apps/Evolution)
- [DAVx5](https://www.davx5.com/tested-with/xandikos/)
- [sogo connector for Icedove/Thunderbird](http://v2.sogo.nu/english/downloads/frontends.html)
- [aCALdav syncer for Android](https://play.google.com/store/apps/details?id=de.we.acaldav&hl=en)
- [pycardsyncer](https://github.com/geier/pycarddav)
- [akonadi](https://community.kde.org/KDE_PIM/Akonadi)
- [CalDAV-Sync](https://dmfs.org/caldav/)
- [CardDAV-Sync](https://dmfs.org/carddav/)
- [Calendarsync](https://play.google.com/store/apps/details?id=com.icalparse)
- [AgendaV](http://agendav.org/)
- [CardBook](https://gitlab.com/cardbook/cardbook/)
- [Tasks](https://github.com/tasks/tasks)
- Apple iOS

If you have tested Xandikos with another CalDAV/CardDAV client, please let us
know so we can (if necessary) fix support for it and add it to the list.

## Client instructions

Some clients can automatically discover the calendar and addressbook URLs from
a DAV server. For such clients you can simply provide the URL to Xandikos directly.

Clients that lack such automated discovery require the direct URL to a calendar
or addressbook. One such client is Thunderbird lightning in which case you
should provide a URL similar to the following:

```
http://dav.example.com/user/calendars/my_calendar
```
