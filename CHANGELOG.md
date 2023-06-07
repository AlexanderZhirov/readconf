# Changelog

## [v0.4.0](https://git.zhirov.kz/dlang/readconf/compare/v0.3.1...v0.4.0) (2023.06.07)

### New

- Reading empty parameter values
- Parameter name as a single character

### Bug fixes

- Generating an exception when accessing a non-existent section

## [v0.3.1](https://git.zhirov.kz/dlang/readconf/compare/v0.3.0...v0.3.1) (2023.04.30)

- Windows OS support

### Update

- `singlog` dependency up to v0.3.0

## [v0.3.0](https://git.zhirov.kz/dlang/readconf/compare/v0.2.0...v0.3.0) (2023.03.30)

### New

- Read multiple configuration files
- Quick access to a file/section/parameter using indexes

### Other

- Updated unittests
- Added [examples](examples/) of configuration files
- [Wiki](https://git.zhirov.kz/dlang/readconf/wiki) added

## [v0.2.0](https://git.zhirov.kz/dlang/readconf/compare/v0.1.1...v0.2.0) (2023.03.26)

### New

- Adding sections support
- Taking into account spaces and tabs to separate the parameter, value and comment
- Added aliases to convenient parameter access to the value

## [v0.1.1](https://git.zhirov.kz/dlang/readconf/compare/v0.1.0...v0.1.1) (2023.03.24)

### Bug fixes

- Checking empty keys
- Reading an expression in quotation marks

## [v0.1.0](https://git.zhirov.kz/dlang/readconf/commits/6409917cbe6a287db73fe3eea4bccaadf00379e7) (2023.03.23)

### The first stable working release

- The parameters are separated by `=` or `=>`
- The ability to comment lines through delimiters `;`, `#`, `//`
