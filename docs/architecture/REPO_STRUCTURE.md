# Repository Structure

This file describes the repository layout in a form suitable for external review and OSS funding applications.

## Top Level

```text
BeeFun-Pro/
├── BeeFun/                 # iOS app workspace and source
├── docs/                   # Application-ready documentation
├── logo/                   # Branding assets
├── screenshot/             # Product screenshots
├── LICENSE
├── README.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
└── SECURITY.md
```

## iOS Project

```text
BeeFun/
├── BeeFun.xcodeproj/
├── BeeFun.xcworkspace/
├── BeeFun/
│   ├── Model/              # Data models (repos/users/issues/events/...)
│   ├── View/               # UI screens and view controllers
│   ├── SystemManager/      # Networking/storage/config/managers
│   ├── ToolKit/            # Shared utilities
│   ├── Resources/          # Images/plist/localization/certs
│   ├── ThirdParty/         # Bundled third-party SDKs/frameworks
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── BeeFun.entitlements
├── XcodeConfig/            # Build configurations
├── Podfile
├── Podfile.lock
└── fastlane/
```

## Documentation

```text
docs/
├── architecture/
│   └── REPO_STRUCTURE.md
├── codex-oss/
│   ├── PROJECT_PROFILE.md
│   ├── FORM_ANSWERS_zh-CN.md
│   └── FORM_ANSWERS_en.md
└── legacy/
    ├── bugs.md
    ├── opensource.md
    ├── other.md
    ├── reference.md
    └── suggestion.md
```

## Notes

- `BeeFun/Pods/` is intentionally ignored from version control.
- Legacy docs are retained under `docs/legacy/` for historical context.
