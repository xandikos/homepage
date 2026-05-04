# Implemented Standards

The following standards are implemented:

- [RFC 4918](https://www.rfc-editor.org/rfc/rfc4918)/[RFC 2518](https://www.rfc-editor.org/rfc/rfc2518) (Core WebDAV) — *implemented, except for COPY/MOVE/LOCK operations*
- [RFC 4791](https://www.rfc-editor.org/rfc/rfc4791) (CalDAV) — *fully implemented*
- [RFC 6352](https://www.rfc-editor.org/rfc/rfc6352) (CardDAV) — *fully implemented*
- [RFC 5397](https://www.rfc-editor.org/rfc/rfc5397) (Current Principal) — *fully implemented*
- [RFC 3253](https://www.rfc-editor.org/rfc/rfc3253) (Versioning Extensions) — *partially implemented, only the REPORT method and {DAV:}expand-property property*
- [RFC 3744](https://www.rfc-editor.org/rfc/rfc3744) (Access Control) — *partially implemented*
- [RFC 5995](https://www.rfc-editor.org/rfc/rfc5995) (POST to create members) — *fully implemented*
- [RFC 5689](https://www.rfc-editor.org/rfc/rfc5689) (Extended MKCOL) — *fully implemented*

The following standards are not implemented:

- [RFC 6638](https://www.rfc-editor.org/rfc/rfc6638) (CalDAV Scheduling Extensions) — *not implemented*
- [RFC 7809](https://www.rfc-editor.org/rfc/rfc7809) (CalDAV Time Zone Extensions) — *not implemented*
- [RFC 7529](https://www.rfc-editor.org/rfc/rfc7529) (WebDAV Quota) — *not implemented*
- [RFC 4709](https://www.rfc-editor.org/rfc/rfc4709) (WebDAV Mount) — [intentionally](https://github.com/jelmer/xandikos/issues/48) *not implemented*
- [RFC 5546](https://www.rfc-editor.org/rfc/rfc5546) (iCal iTIP) — *not implemented*
- [RFC 4324](https://www.rfc-editor.org/rfc/rfc4324) (iCAL CAP) — *not implemented*
- [RFC 7953](https://www.rfc-editor.org/rfc/rfc7953) (iCal AVAILABILITY) — *not implemented*

See [DAV compliance](https://github.com/jelmer/xandikos/blob/master/notes/dav-compliance.rst) for more detail on specification compliancy.
